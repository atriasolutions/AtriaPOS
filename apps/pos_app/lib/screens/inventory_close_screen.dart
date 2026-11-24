import 'package:core/api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../di/pos_composition.dart';

class InventoryCloseScreen extends StatefulWidget {
  const InventoryCloseScreen({super.key, required this.composition});

  final PosComposition composition;

  @override
  State<InventoryCloseScreen> createState() => _InventoryCloseScreenState();
}

class _InventoryCloseScreenState extends State<InventoryCloseScreen> {
  InventoryClosePreviewResponse? _preview;
  final Map<String, TextEditingController> _countControllers = {};
  bool _loading = true;
  bool _submitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPreview();
  }

  @override
  void dispose() {
    for (final c in _countControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _syncControllers(InventoryClosePreviewResponse preview) {
    for (final old in _countControllers.values) {
      old.dispose();
    }
    _countControllers.clear();
    for (final item in preview.items) {
      _countControllers[item.productId] = TextEditingController(
        text: '${item.systemStock}',
      );
    }
  }

  Future<void> _loadPreview() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await widget.composition.inventoryService
        .getInventoryClosePreview(widget.composition.requireStoreId);
    if (!mounted) return;
    switch (result) {
      case ApiSuccess<InventoryClosePreviewResponse>(data: final data):
        setState(() {
          _preview = data;
          _syncControllers(data);
          _loading = false;
        });
      case ApiFailure<InventoryClosePreviewResponse>(error: final e):
        setState(() {
          _preview = null;
          _error = e.message;
          _loading = false;
        });
    }
  }

  Future<void> _submit() async {
    final preview = _preview;
    if (preview == null) return;

    final lines = <InventoryCloseLineRequest>[];
    for (final item in preview.items) {
      final controller = _countControllers[item.productId];
      if (controller == null) continue;
      final counted = int.tryParse(controller.text.trim());
      if (counted == null || counted < 0) {
        _snack('Ingrese cantidades válidas para ${item.name}.');
        return;
      }
      lines.add(
        InventoryCloseLineRequest(
          productId: item.productId,
          countedQty: counted,
        ),
      );
    }

    setState(() => _submitting = true);
    final result = await widget.composition.inventoryService.submitInventoryClose(
      widget.composition.requireStoreId,
      InventoryCloseSubmitRequest(lines: lines),
    );
    if (!mounted) return;
    setState(() => _submitting = false);
    switch (result) {
      case ApiSuccess<InventoryCloseSubmitResponse>(data: final data):
        final withVariance = data.lines.where((l) => l.variance != 0).toList();
        final summary = withVariance.isEmpty
            ? 'Cierre registrado sin correcciones de stock.'
            : 'Cierre registrado. ${withVariance.length} línea(s) con ajuste.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            key: const Key('inventory_close_success'),
            content: Text(summary),
          ),
        );
        await _loadPreview();
      case ApiFailure<InventoryCloseSubmitResponse>(error: final e):
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
    final preview = _preview;
    final noShift = !_loading && preview == null && _error != null;

    return Scaffold(
      appBar: AppBar(title: const Text('Cierre inventario')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : noShift
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      _error!,
                      key: const Key('inventory_close_no_shift'),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        key: const Key('inventory_close_list'),
                        padding: const EdgeInsets.all(16),
                        itemCount: preview!.items.length,
                        itemBuilder: (context, index) {
                          final item = preview.items[index];
                          final controller = _countControllers[item.productId]!;
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    item.name,
                                    key: Key('inventory_close_name_${item.productId}'),
                                    style: Theme.of(context).textTheme.titleSmall,
                                  ),
                                  Text(
                                    'Stock sistema: ${item.systemStock}',
                                    key: Key(
                                      'inventory_close_system_${item.productId}',
                                    ),
                                  ),
                                  Text(
                                    'Vendidos en turno: ${item.unitsSoldInShift}',
                                    key: Key(
                                      'inventory_close_sold_${item.productId}',
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextField(
                                    key: Key(
                                      'inventory_close_count_${item.productId}',
                                    ),
                                    controller: controller,
                                    decoration: const InputDecoration(
                                      labelText: 'Cantidad contada',
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: FilledButton(
                        key: const Key('inventory_close_submit_button'),
                        onPressed: _submitting ? null : _submit,
                        child: _submitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Registrar cierre'),
                      ),
                    ),
                  ],
                ),
    );
  }
}