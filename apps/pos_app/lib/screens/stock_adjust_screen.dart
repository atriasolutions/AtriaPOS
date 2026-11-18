import 'package:core/api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../di/pos_composition.dart';

class StockAdjustScreen extends StatefulWidget {
  const StockAdjustScreen({super.key, required this.composition});

  final PosComposition composition;

  @override
  State<StockAdjustScreen> createState() => _StockAdjustScreenState();
}

class _StockAdjustScreenState extends State<StockAdjustScreen> {
  final _searchController = TextEditingController();
  final _deltaController = TextEditingController();
  String _reason = 'MERMA';
  String? _selectedProductId;
  String? _selectedProductName;
  int? _selectedStock;
  List<ProductSearchItem> _searchResults = [];
  bool _loading = false;
  bool _submitting = false;

  @override
  void dispose() {
    _searchController.dispose();
    _deltaController.dispose();
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

  Future<void> _submit() async {
    final productId = _selectedProductId;
    if (productId == null) {
      _snack('Seleccione un producto.');
      return;
    }
    final delta = int.tryParse(_deltaController.text.trim());
    if (delta == null || delta == 0) {
      _snack('Ingrese un delta distinto de cero.');
      return;
    }
    setState(() => _submitting = true);
    final result = await widget.composition.inventoryService.adjustStock(
      widget.composition.requireStoreId,
      productId,
      AdjustStockRequest(delta: delta, reason: _reason),
    );
    if (!mounted) return;
    setState(() => _submitting = false);
    switch (result) {
      case ApiSuccess<AdjustStockResponse>(data: final data):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            key: const Key('stock_adjust_success_snackbar'),
            content: Text('Stock actualizado: ${data.stock} unidades.'),
          ),
        );
        setState(() {
          _selectedStock = data.stock;
          _deltaController.clear();
        });
      case ApiFailure<AdjustStockResponse>(error: final e):
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
      appBar: AppBar(title: const Text('Ajuste de stock')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              key: const Key('stock_adjust_search_field'),
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
                      key: Key('stock_pick_${p.id}'),
                      title: Text(p.name),
                      subtitle: Text('Stock ${p.stock}'),
                      onTap: () => _selectProduct(p),
                    );
                  },
                ),
              ),
            if (_selectedProductName != null)
              Text(
                key: const Key('stock_adjust_selected_label'),
                'Producto: $_selectedProductName (stock $_selectedStock)',
              ),
            const SizedBox(height: 12),
            TextField(
              key: const Key('stock_adjust_delta_field'),
              controller: _deltaController,
              decoration: const InputDecoration(
                labelText: 'Delta (ej. -1 merma)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^-?\d*')),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              key: const Key('stock_adjust_reason_field'),
              value: _reason,
              decoration: const InputDecoration(
                labelText: 'Motivo',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'MERMA', child: Text('Merma')),
                DropdownMenuItem(value: 'AJUSTE', child: Text('Ajuste')),
                DropdownMenuItem(value: 'CORRECCION', child: Text('Corrección')),
              ],
              onChanged: (v) {
                if (v != null) setState(() => _reason = v);
              },
            ),
            const SizedBox(height: 24),
            FilledButton(
              key: const Key('stock_adjust_submit_button'),
              onPressed: _submitting ? null : _submit,
              child: _submitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Registrar ajuste'),
            ),
          ],
        ),
      ),
    );
  }
}