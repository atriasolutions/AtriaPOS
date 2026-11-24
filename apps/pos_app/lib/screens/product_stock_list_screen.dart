import 'package:core/api/api.dart';
import 'package:core/domain/domain.dart';
import 'package:flutter/material.dart';

import '../di/pos_composition.dart';
import '../export/qr_labels_pdf.dart';
import '../util/api_failure_handler.dart';

class ProductStockListScreen extends StatefulWidget {
  const ProductStockListScreen({super.key, required this.composition});

  final PosComposition composition;

  @override
  State<ProductStockListScreen> createState() => _ProductStockListScreenState();
}

class _ProductStockListScreenState extends State<ProductStockListScreen> {
  List<ProductResponse> _all = [];
  List<ProductResponse> _visible = [];
  final _queryController = TextEditingController();
  final Set<String> _selectedIds = {};
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await widget.composition.productService.listStoreProducts(
      widget.composition.requireStoreId,
    );
    if (!mounted) return;
    switch (result) {
      case ApiSuccess<ListStoreProductsResponse>(data: final data):
        setState(() {
          _all = data.items;
          _visible = data.items;
          _loading = false;
        });
      case ApiFailure<ListStoreProductsResponse>(error: final e):
        if (handleApiFailure(context, widget.composition, e)) return;
        setState(() {
          _error = e.message;
          _loading = false;
        });
    }
  }

  void _applyFilter(String query) {
    final q = query.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _visible = _all;
      } else {
        _visible = _all.where((p) => p.name.toLowerCase().contains(q)).toList();
      }
    });
  }

  void _toggleSelection(String id, bool? selected) {
    setState(() {
      if (selected == true) {
        _selectedIds.add(id);
      } else {
        _selectedIds.remove(id);
      }
    });
  }

  Future<void> _exportPdf() async {
    final selected = _all.where((p) => _selectedIds.contains(p.id)).toList();
    if (selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Seleccione al menos un producto.')),
      );
      return;
    }
    await exportQrLabelsPdf(context, selected);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock de productos'),
        actions: [
          IconButton(
            key: const Key('product_stock_export_pdf'),
            tooltip: 'Exportar etiquetas QR',
            onPressed: _selectedIds.isEmpty ? null : _exportPdf,
            icon: const Icon(Icons.picture_as_pdf_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              key: const Key('product_stock_filter_field'),
              controller: _queryController,
              decoration: const InputDecoration(
                labelText: 'Filtrar por nombre',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _applyFilter,
            ),
          ),
          if (_loading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (_error != null)
            Expanded(child: Center(child: Text(_error!)))
          else
            Expanded(
              child: RefreshIndicator(
                onRefresh: _load,
                child: ListView.builder(
                  key: const Key('product_stock_list'),
                  itemCount: _visible.length,
                  itemBuilder: (context, index) {
                    final p = _visible[index];
                    return CheckboxListTile(
                      key: Key('product_stock_row_${p.id}'),
                      value: _selectedIds.contains(p.id),
                      onChanged: (v) => _toggleSelection(p.id, v),
                      title: Text(p.name),
                      subtitle: Text(
                        '\$${p.salePriceClp} · stock ${p.stock}',
                      ),
                      secondary: const Icon(Icons.inventory_2_outlined),
                    );
                  },
                ),
              ),
            ),
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              'Código de barras en etiquetas: próximamente.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}