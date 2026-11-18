import 'package:core/api/api.dart';
import 'package:flutter/material.dart';

import '../config/store_config.dart';
import '../di/pos_composition.dart';
import '../widgets/checkout_dialog.dart';

class SaleScreen extends StatefulWidget {
  const SaleScreen({super.key, required this.composition});

  final PosComposition composition;

  @override
  State<SaleScreen> createState() => _SaleScreenState();
}

class _SaleScreenState extends State<SaleScreen> {
  final _searchController = TextEditingController();
  String? _cartId;
  CartResponse? _cart;
  List<ProductSearchItem> _searchResults = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _ensureCart();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _ensureCart() async {
    if (_cartId != null) return;
    final created = await widget.composition.saleService.createCart(kDemoStoreId);
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
      kDemoStoreId,
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
      kDemoStoreId,
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
      kDemoStoreId,
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

    final created = await widget.composition.saleService.createCart(kDemoStoreId);
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
    return Scaffold(
      appBar: AppBar(title: const Text('Vender')),
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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