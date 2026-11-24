import 'package:core/api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../di/pos_composition.dart';

class StockReceiptScreen extends StatefulWidget {
  const StockReceiptScreen({super.key, required this.composition});

  final PosComposition composition;

  @override
  State<StockReceiptScreen> createState() => _StockReceiptScreenState();
}

class _StockReceiptScreenState extends State<StockReceiptScreen> {
  final _searchController = TextEditingController();
  final _quantityController = TextEditingController();
  final _guideController = TextEditingController();
  final _lotController = TextEditingController();
  String? _selectedProductId;
  String? _selectedProductName;
  int? _selectedStock;
  List<ProductSearchItem> _searchResults = [];
  bool _loading = false;
  bool _submitting = false;

  @override
  void dispose() {
    _searchController.dispose();
    _quantityController.dispose();
    _guideController.dispose();
    _lotController.dispose();
    super.dispose();
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

  void _selectProduct(ProductSearchItem product) {
    setState(() {
      _selectedProductId = product.id;
      _selectedProductName = product.name;
      _selectedStock = product.stock;
      _searchResults = [];
      _searchController.text = product.name;
    });
  }

  bool _validateForm() {
    if (_selectedProductId == null) {
      _snack('Seleccione un producto.');
      return false;
    }
    final quantity = int.tryParse(_quantityController.text.trim());
    if (quantity == null || quantity <= 0) {
      _snack('Ingrese una cantidad mayor a cero.');
      return false;
    }
    final guide = _guideController.text.trim();
    final lot = _lotController.text.trim();
    if (guide.isEmpty) {
      _snack('Ingrese la referencia de guía.');
      return false;
    }
    if (lot.isEmpty) {
      _snack('Ingrese la referencia de lote.');
      return false;
    }
    return true;
  }

  Future<void> _submit() async {
    if (!_validateForm()) return;
    final productId = _selectedProductId!;
    final quantity = int.parse(_quantityController.text.trim());
    final guide = _guideController.text.trim();
    final lot = _lotController.text.trim();

    setState(() => _submitting = true);
    final result = await widget.composition.inventoryService.recordStockReceipt(
      widget.composition.requireStoreId,
      productId,
      StockReceiptRequest(
        quantity: quantity,
        guideRef: guide,
        lotRef: lot,
      ),
    );
    if (!mounted) return;
    setState(() => _submitting = false);
    switch (result) {
      case ApiSuccess<StockReceiptResponse>(data: final data):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            key: const Key('stock_receipt_success_snackbar'),
            content: Text(
              'Ingreso registrado: ${data.stock} u. '
              'Guía ${data.guideRef}, lote ${data.lotRef}.',
            ),
          ),
        );
        setState(() {
          _selectedStock = data.stock;
          _quantityController.clear();
        });
      case ApiFailure<StockReceiptResponse>(error: final e):
        _snack(e.message);
    }
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ingreso existencias')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              key: const Key('stock_receipt_search_field'),
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
            if (_searchResults.isNotEmpty)
              SizedBox(
                height: 120,
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final p = _searchResults[index];
                    return ListTile(
                      key: Key('stock_receipt_pick_${p.id}'),
                      title: Text(p.name),
                      subtitle: Text('Stock ${p.stock}'),
                      onTap: () => _selectProduct(p),
                    );
                  },
                ),
              ),
            if (_selectedProductName != null)
              Text(
                key: const Key('stock_receipt_selected_label'),
                'Producto: $_selectedProductName (stock $_selectedStock)',
              ),
            const SizedBox(height: 12),
            TextField(
              key: const Key('stock_receipt_quantity_field'),
              controller: _quantityController,
              decoration: const InputDecoration(
                labelText: 'Cantidad',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 12),
            TextField(
              key: const Key('stock_receipt_guide_field'),
              controller: _guideController,
              decoration: const InputDecoration(
                labelText: 'Guía',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              key: const Key('stock_receipt_lot_ref_field'),
              controller: _lotController,
              decoration: const InputDecoration(
                labelText: 'Lote',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              key: const Key('stock_receipt_submit_button'),
              onPressed: _submitting ? null : _submit,
              child: _submitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Registrar ingreso'),
            ),
          ],
        ),
      ),
    );
  }
}