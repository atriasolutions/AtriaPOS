import 'dart:async';

import 'package:core/api/api.dart';
import 'package:core/domain/domain.dart';
import 'package:flutter/material.dart';

import '../di/pos_composition.dart';
import '../widgets/checkout_dialog.dart';
import 'close_shift_screen.dart';
import 'daily_sales_screen.dart';
import 'dte_queue_screen.dart';
import 'shift_sales_screen.dart';
import 'product_create_screen.dart';
import 'stock_adjust_screen.dart';

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

  @override
  void initState() {
    super.initState();
    _ensureCart();
    _scanSub = widget.composition.scannerIngress.scans.listen(_onScan);
    unawaited(widget.composition.scannerIngress.start());
  }

  @override
  void dispose() {
    _scanSub?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _onScan(String raw) async {
    _searchController.text = raw;
    await _search();
    if (_searchResults.length == 1) {
      await _addProduct(_searchResults.first);
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

    final folioText =
        response.folio != null ? ' Folio ${response.folio}.' : '';
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        key: const Key('checkout_result_dialog'),
        title: const Text('Venta registrada'),
        content: Text(
          'Total: \$${response.totalClp}\n'
          'Fecha: ${formatChileDateTime(DateTime.parse(response.createdAt))}\n'
          'Boleta: ${response.dteStatus}.$folioText',
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
    final hasOpsMenu = canVoidSales ||
        canCloseShift ||
        canAdjustStock ||
        canDteQueue ||
        canCreateProduct ||
        canDailyReport;

    void openScreen(Widget screen) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => screen),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vender'),
        actions: [
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
                  case 'daily':
                    openScreen(
                      DailySalesScreen(composition: widget.composition),
                    );
                  case 'stock':
                    openScreen(
                      StockAdjustScreen(composition: widget.composition),
                    );
                  case 'product':
                    openScreen(
                      ProductCreateScreen(composition: widget.composition),
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
                if (canDailyReport)
                  const PopupMenuItem(
                    value: 'daily',
                    child: Text(
                      'Ventas del día',
                      key: Key('operation_menu_daily_report'),
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