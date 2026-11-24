import 'dart:async';

import 'package:core/api/api.dart';
import 'package:core/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../di/pos_composition.dart';
import '../util/api_failure_handler.dart';
import 'close_shift_screen.dart';
import '../scanner/ble_central_scanner_ingress.dart';
import '../scanner/scanner_connection_state.dart';
import '../widgets/atria_bordered_panel.dart';
import '../widgets/atria_sale_top_bar.dart';
import '../widgets/checkout_panel.dart';

class SaleScreen extends StatefulWidget {
  const SaleScreen({
    super.key,
    required this.composition,
    this.lastShiftOpenedAt,
  });

  final PosComposition composition;
  final String? lastShiftOpenedAt;

  @override
  State<SaleScreen> createState() => _SaleScreenState();
}

class _SaleScreenState extends State<SaleScreen> {
  final _searchController = TextEditingController();
  String? _cartId;
  CartResponse? _cart;
  List<ProductSearchItem> _searchResults = [];
  bool _loading = false;
  StreamSubscription<String>? _scanSub;
  StreamSubscription<ScannerConnectionState>? _scannerStateSub;
  ScannerConnectionState _scannerState = ScannerConnectionState.disconnected;
  PosTemplateId _templateId = PosTemplateId.atriaPos;
  bool _templateResolved = false;

  @override
  void initState() {
    super.initState();
    unawaited(_bootstrapSaleScreen());
  }

  Future<void> _bootstrapSaleScreen() async {
    await _loadTemplateId();
    if (!mounted) return;
    setState(() => _templateResolved = true);
    await _ensureCart();
    _scanSub = widget.composition.scannerIngress.scans.listen(_onScan);
    unawaited(widget.composition.scannerIngress.start());
    final ble = _bleIngress;
    if (ble != null) {
      _scannerStateSub = ble.connectionState.listen((s) {
        if (!mounted) return;
        setState(() => _scannerState = s);
        if (s == ScannerConnectionState.error) {
          final message = ble.pairingErrorMessage;
          if (message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          }
        }
      });
    }
  }

  Future<void> _changeSession() async {
    final result = await widget.composition.authService.endSession(
      widget.composition.requireStoreId,
    );
    if (!mounted) return;
    switch (result) {
      case ApiSuccess<void>():
        setState(() {
          _cartId = null;
          _cart = null;
          _searchResults = [];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Sesión cerrada. El carrito local se reinició. Inicie sesión.',
            ),
          ),
        );
        widget.composition.notifySessionExpired();
      case ApiFailure<void>(error: final e):
        if (handleApiFailure(context, widget.composition, e)) return;
        if (e.code == 'VALIDACION') {
          await showDialog<void>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Cambiar sesión'),
              content: Text(e.message),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  key: const Key('change_session_open_close_shift'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            CloseShiftScreen(composition: widget.composition),
                      ),
                    );
                  },
                  child: const Text('Ir a cerrar caja'),
                ),
              ],
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message)),
          );
        }
    }
  }

  Future<void> _loadTemplateId() async {
    final id = await widget.composition.resolveActiveTemplateId();
    if (!mounted) return;
    setState(() => _templateId = id);
  }

  List<PosMenuEntry> _visibleMenuEntries(UserRole? role) {
    if (role == null) return const [];
    return PosMenuPolicy.visibleForTemplateId(role, _templateId);
  }

  BleCentralScannerIngress? get _bleIngress {
    final ingress = widget.composition.scannerIngress;
    return ingress is BleCentralScannerIngress ? ingress : null;
  }

  @override
  void dispose() {
    _scanSub?.cancel();
    _scannerStateSub?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _onScan(String raw) async {
    _searchController.text = raw;
    await _search();
    if (_searchResults.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sin productos para: $raw')),
      );
      return;
    }
    if (_searchResults.length == 1) {
      await _addProduct(_searchResults.first);
    }
  }

  Future<void> _openScannerPairing() async {
    final ble = _bleIngress;
    if (ble == null) return;
    final code = ble.pairingCode ?? ble.generatePairingCode();
    unawaited(ble.startPairing(pairingCode: code));
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Pareo escáner'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Ingrese este código en la app escáner del teléfono:',
              ),
              const SizedBox(height: 12),
              Text(
                code,
                key: const Key('scanner_pairing_code'),
                style: Theme.of(ctx).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              if (_scannerState == ScannerConnectionState.connected)
                const Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Text(
                    'Escáner conectado',
                    key: Key('scanner_status_connected'),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  String _scannerStatusLabel() {
    switch (_scannerState) {
      case ScannerConnectionState.connected:
        return 'Conectado';
      case ScannerConnectionState.scanning:
        return 'Buscando…';
      case ScannerConnectionState.connecting:
        return 'Conectando…';
      case ScannerConnectionState.error:
        return 'Error BLE';
      case ScannerConnectionState.disconnected:
        return 'Desconectado';
    }
  }

  Future<void> _ensureCart() async {
    if (_cartId != null) return;
    final created = await widget.composition.saleService.createCart(widget.composition.requireStoreId);
    switch (created) {
      case ApiSuccess<CreateCartResponse>(data: final data):
        setState(() => _cartId = data.cartId);
        await _refreshCart();
      case ApiFailure<CreateCartResponse>():
        break;
    }
  }

  Future<void> _refreshCart() async {
    final cartId = _cartId;
    if (cartId == null) return;
    final result = await widget.composition.saleService.getCart(
      widget.composition.requireStoreId,
      cartId,
    );
    if (!mounted) return;
    if (result case ApiSuccess<CartResponse>(data: final data)) {
      setState(() => _cart = data);
    }
  }

  Future<void> _search() async {
    final query = _searchController.text.trim();
    if (query.length < 2) {
      setState(() => _searchResults = []);
      return;
    }
    setState(() => _loading = true);
    final result = await widget.composition.productService.searchProducts(
      widget.composition.requireStoreId,
      query,
    );
    if (!mounted) return;
    setState(() => _loading = false);
    if (result case ApiSuccess<SearchProductsResponse>(data: final data)) {
      setState(() => _searchResults = data.items);
    }
  }

  Future<void> _addProduct(ProductSearchItem product) async {
    final cartId = _cartId;
    if (cartId == null) return;
    final result = await widget.composition.saleService.addLine(
      widget.composition.requireStoreId,
      cartId,
      AddCartLineRequest(productId: product.id, quantity: 1),
    );
    if (!mounted) return;
    switch (result) {
      case ApiSuccess<CartResponse>():
        await _refreshCart();
      case ApiFailure<CartResponse>(error: final e):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
    }
  }

  Future<void> _updateLineQuantity(String lineId, int newQuantity) async {
    final cartId = _cartId;
    if (cartId == null || newQuantity < 1) return;
    final result = await widget.composition.saleService.updateLine(
      widget.composition.requireStoreId,
      cartId,
      lineId,
      UpdateCartLineRequest(quantity: newQuantity),
    );
    if (!mounted) return;
    switch (result) {
      case ApiSuccess<CartResponse>():
        await _refreshCart();
      case ApiFailure<CartResponse>(error: final e):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
    }
  }

  Future<void> _removeLine(String lineId) async {
    final cartId = _cartId;
    if (cartId == null) return;
    final result = await widget.composition.saleService.removeLine(
      widget.composition.requireStoreId,
      cartId,
      lineId,
    );
    if (!mounted) return;
    switch (result) {
      case ApiSuccess<void>():
        await _refreshCart();
      case ApiFailure<void>(error: final e):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
    }
  }

  Future<void> _onCheckoutSuccess(CheckoutResponse response) async {
    final folioLine =
        response.folio != null ? 'Folio: ${response.folio}' : null;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        key: const Key('checkout_result_dialog'),
        title: const Text('Venta registrada'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total: \$${response.totalClp}'),
            Text(
              'Fecha: ${formatChileDateTime(DateTime.parse(response.createdAt))}',
            ),
            Text('Boleta: ${response.dteStatus}'),
            if (folioLine != null) Text(folioLine),
            Text(
              key: const Key('checkout_sale_id_label'),
              'Venta (sale_id): ${response.saleId}',
            ),
          ],
        ),
        actions: [
          TextButton(
            key: const Key('checkout_copy_sale_id_button'),
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: response.saleId));
              if (!ctx.mounted) return;
              ScaffoldMessenger.of(ctx).showSnackBar(
                const SnackBar(
                  key: Key('checkout_sale_id_copied_snackbar'),
                  content: Text('sale_id copiado al portapapeles.'),
                ),
              );
            },
            child: const Text('Copiar sale_id'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Listo'),
          ),
        ],
      ),
    );

    final created = await widget.composition.saleService.createCart(widget.composition.requireStoreId);
    if (created case ApiSuccess<CreateCartResponse>(data: final data)) {
      setState(() {
        _cartId = data.cartId;
        _cart = null;
        _searchResults = [];
        _searchController.clear();
      });
      await _refreshCart();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_templateResolved) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final cart = _cart;
    final session = widget.composition.sessionProvider.current;
    final role = session?.role;
    final visibleMenu = _visibleMenuEntries(role);
    final requiresSellerCode =
        CheckoutTemplatePolicy.requiresSellerCode(_templateId);
    final hasOpsMenu = visibleMenu.isNotEmpty;
    final showProductStock = role != null &&
        AuthPolicy.allows(role, Permission.consultarStock);

    final cartHasLines = cart != null && cart.lines.isNotEmpty;
    final totalClp = cart?.totalClp ?? 0;

    Widget? scannerAction;
    if (_bleIngress != null) {
      scannerAction = TextButton.icon(
        key: const Key('scanner_connect_button'),
        onPressed: _openScannerPairing,
        icon: const Icon(Icons.bluetooth),
        label: Text('Escáner: ${_scannerStatusLabel()}'),
      );
    }

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (hasOpsMenu || scannerAction != null || showProductStock)
            AtriaSaleTopBar(
              composition: widget.composition,
              visibleEntries: visibleMenu,
              showProductStock: showProductStock,
              onChangeSession: _changeSession,
              scannerAction: scannerAction,
            )
          else if (scannerAction != null)
            Align(alignment: Alignment.centerRight, child: scannerAction),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: AtriaBorderedPanel(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (widget.lastShiftOpenedAt != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                key: const Key('shift_open_time_label'),
                                'Turno abierto: ${formatChileDateTime(DateTime.parse(widget.lastShiftOpenedAt!))}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          TextField(
                            key: const Key('product_search_field'),
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Buscar o escanear...',
                              suffixIcon: IconButton(
                                key: const Key('product_search_submit'),
                                icon: const Icon(Icons.search),
                                onPressed: _search,
                              ),
                            ),
                            onSubmitted: (_) => _search(),
                          ),
                          if (_loading) const LinearProgressIndicator(),
                          if (_searchResults.isNotEmpty)
                            SizedBox(
                              height: 140,
                              child: ListView.builder(
                                itemCount: _searchResults.length,
                                itemBuilder: (context, index) {
                                  final p = _searchResults[index];
                                  return ListTile(
                                    key: Key('product_tile_${p.id}'),
                                    title: Text(p.name),
                                    subtitle: Text(
                                      '\$${p.salePriceClp} · stock ${p.stock}',
                                    ),
                                    onTap: () => _addProduct(p),
                                  );
                                },
                              ),
                            ),
                          Expanded(
                            child: !cartHasLines
                                ? Center(
                                    child: Column(
                                      key: const Key('sale_cart_empty_state'),
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.shopping_cart_outlined,
                                          size: 56,
                                          color: Colors.grey.shade400,
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          'El carrito está vacío.',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Busca o escanea productos para comenzar.',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: cart!.lines.length,
                                    itemBuilder: (context, index) {
                                      final line = cart.lines[index];
                                      return Card(
                                        key: Key('cart_line_${line.lineId}'),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      line.name,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleMedium,
                                                    ),
                                                    Text(
                                                      '\$${line.unitPriceClp} c/u',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              IconButton(
                                                key: Key(
                                                  'cart_line_qty_minus_${line.lineId}',
                                                ),
                                                onPressed: line.quantity > 1
                                                    ? () => _updateLineQuantity(
                                                          line.lineId,
                                                          line.quantity - 1,
                                                        )
                                                    : null,
                                                icon: const Icon(Icons.remove),
                                              ),
                                              Text(
                                                key: Key(
                                                  'cart_line_qty_label_${line.lineId}',
                                                ),
                                                '${line.quantity}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium,
                                              ),
                                              IconButton(
                                                key: Key(
                                                  'cart_line_qty_plus_${line.lineId}',
                                                ),
                                                onPressed: () =>
                                                    _updateLineQuantity(
                                                  line.lineId,
                                                  line.quantity + 1,
                                                ),
                                                icon: const Icon(Icons.add),
                                              ),
                                              IconButton(
                                                key: Key(
                                                  'cart_line_remove_${line.lineId}',
                                                ),
                                                tooltip: 'Quitar',
                                                onPressed: () =>
                                                    _removeLine(line.lineId),
                                                icon: const Icon(
                                                  Icons.delete_outline,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AtriaBorderedPanel(
                      child: CheckoutPanel(
                        composition: widget.composition,
                        cartId: _cartId,
                        totalClp: totalClp,
                        enabled: cartHasLines,
                        requiresSellerCode: requiresSellerCode,
                        onSuccess: _onCheckoutSuccess,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}