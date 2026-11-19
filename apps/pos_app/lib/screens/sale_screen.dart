import 'dart:async';

import 'package:core/api/api.dart';
import 'package:core/domain/domain.dart';
import 'package:flutter/material.dart';

import '../di/pos_composition.dart';
import '../scanner/ble_central_scanner_ingress.dart';
import '../scanner/scanner_connection_state.dart';
import '../widgets/checkout_dialog.dart';
import 'close_shift_screen.dart';
import 'audit_trail_screen.dart';
import 'certificate_status_screen.dart';
import 'daily_sales_screen.dart';
import 'dte_queue_screen.dart';
import 'shift_sales_screen.dart';
import 'product_create_screen.dart';
import 'stock_adjust_screen.dart';
import 'user_create_screen.dart';

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

  @override
  void initState() {
    super.initState();
    _ensureCart();
    _scanSub = widget.composition.scannerIngress.scans.listen(_onScan);
    unawaited(widget.composition.scannerIngress.start());
    final ble = _bleIngress;
    if (ble != null) {
      _scannerStateSub = ble.connectionState.listen((s) {
        if (mounted) setState(() => _scannerState = s);
      });
    }
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

  Future<void> _checkout() async {
    final cart = _cart;
    final cartId = _cartId;
    if (cart == null || cartId == null || cart.lines.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agregue productos al carro primero.')),
      );
      return;
    }
    final response = await showCheckoutDialog(
      context: context,
      composition: widget.composition,
      cartId: cartId,
      totalClp: cart.totalClp,
    );
    if (response == null || !mounted) return;

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
    final cart = _cart;
    final session = widget.composition.sessionProvider.current;
    final role = session?.role;
    final canVoidSales = session != null &&
        AuthPolicy.allows(session.role, Permission.anularVenta);
    final canCloseShift = session != null &&
        AuthPolicy.allows(session.role, Permission.cerrarCaja);
    final canAdjustStock = session != null &&
        AuthPolicy.allows(session.role, Permission.ajustarInventario);
    final canDteQueue =
        role == UserRole.dueno || role == UserRole.supervisor;
    final canDailyReport = canDteQueue;
    final canCreateProduct = session != null &&
        AuthPolicy.allows(session.role, Permission.configurarCatalogo);
    final canManageUsers = session != null &&
        AuthPolicy.allows(session.role, Permission.gestionarUsuarios);
    final hasOpsMenu = canVoidSales ||
        canCloseShift ||
        canAdjustStock ||
        canDteQueue ||
        canCreateProduct ||
        canDailyReport ||
        canManageUsers;

    void openScreen(Widget screen) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => screen),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vender'),
        actions: [
          if (_bleIngress != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: TextButton.icon(
                key: const Key('scanner_connect_button'),
                onPressed: _openScannerPairing,
                icon: const Icon(Icons.bluetooth),
                label: Text('Escáner: ${_scannerStatusLabel()}'),
              ),
            ),
          if (hasOpsMenu)
            PopupMenuButton<String>(
              key: const Key('operation_menu_button'),
              tooltip: 'Operación',
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                switch (value) {
                  case 'sales':
                    openScreen(
                      ShiftSalesScreen(composition: widget.composition),
                    );
                  case 'close':
                    openScreen(
                      CloseShiftScreen(composition: widget.composition),
                    );
                  case 'dte':
                    openScreen(
                      DteQueueScreen(composition: widget.composition),
                    );
                  case 'certificate':
                    openScreen(
                      CertificateStatusScreen(composition: widget.composition),
                    );
                  case 'daily':
                    openScreen(
                      DailySalesScreen(composition: widget.composition),
                    );
                  case 'audit':
                    openScreen(
                      AuditTrailScreen(composition: widget.composition),
                    );
                  case 'stock':
                    openScreen(
                      StockAdjustScreen(composition: widget.composition),
                    );
                  case 'product':
                    openScreen(
                      ProductCreateScreen(composition: widget.composition),
                    );
                  case 'users':
                    openScreen(
                      UserCreateScreen(composition: widget.composition),
                    );
                }
              },
              itemBuilder: (context) => [
                if (canVoidSales)
                  const PopupMenuItem(
                    value: 'sales',
                    child: Text(
                      'Ventas del turno',
                      key: Key('operation_menu_sales'),
                    ),
                  ),
                if (canCloseShift)
                  const PopupMenuItem(
                    value: 'close',
                    child: Text(
                      'Cerrar caja',
                      key: Key('operation_menu_close'),
                    ),
                  ),
                if (canDteQueue)
                  const PopupMenuItem(
                    value: 'dte',
                    child: Text(
                      'Cola DTE',
                      key: Key('operation_menu_dte'),
                    ),
                  ),
                if (canDteQueue)
                  const PopupMenuItem(
                    value: 'certificate',
                    child: Text(
                      'Certificado SII',
                      key: Key('operation_menu_certificate'),
                    ),
                  ),
                if (canDailyReport)
                  const PopupMenuItem(
                    value: 'daily',
                    child: Text(
                      'Ventas del día',
                      key: Key('operation_menu_daily_report'),
                    ),
                  ),
                if (canVoidSales)
                  const PopupMenuItem(
                    value: 'audit',
                    child: Text(
                      'Auditoría del día',
                      key: Key('operation_menu_audit'),
                    ),
                  ),
                if (canAdjustStock)
                  const PopupMenuItem(
                    value: 'stock',
                    child: Text(
                      'Ajuste de stock',
                      key: Key('operation_menu_stock'),
                    ),
                  ),
                if (canCreateProduct)
                  const PopupMenuItem(
                    value: 'product',
                    child: Text(
                      'Nuevo producto',
                      key: Key('operation_menu_product'),
                    ),
                  ),
                if (canManageUsers)
                  const PopupMenuItem(
                    value: 'users',
                    child: Text(
                      'Nuevo usuario',
                      key: Key('operation_menu_users'),
                    ),
                  ),
              ],
            ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
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
                      labelText: 'Buscar producto',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: _search,
                      ),
                    ),
                    onSubmitted: (_) => _search(),
                  ),
                  if (_loading) const LinearProgressIndicator(),
                  Expanded(
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
                  if (_bleIngress != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Piloto escáner BLE',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Column(
                      key: const Key('scanner_pilot_guide'),
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('1. Índice: runbooks/ble-piloto-indice.md'),
                        Text('2. Pareo: runbooks/ble-scanner-pairing.md'),
                        Text('3. Botón Conectar escáner → código 4 dígitos'),
                        Text('4. Companion Android: anunciar y escanear'),
                        Text('5. QR producto → línea en carro'),
                        Text('6. Evidencia: runbooks/ble-scanner-pilot-evidence.md'),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Carro',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: cart == null || cart.lines.isEmpty
                        ? const Center(child: Text('Carro vacío'))
                        : ListView.builder(
                            itemCount: cart.lines.length,
                            itemBuilder: (context, index) {
                              final line = cart.lines[index];
                              return ListTile(
                                title: Text(line.name),
                                subtitle: Text(
                                  '${line.quantity} x \$${line.unitPriceClp}',
                                ),
                              );
                            },
                          ),
                  ),
                  Text(
                    key: const Key('cart_total_label'),
                    'Total: \$${cart?.totalClp ?? 0}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    key: const Key('checkout_button'),
                    onPressed: _checkout,
                    child: const Text('Cobrar'),
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