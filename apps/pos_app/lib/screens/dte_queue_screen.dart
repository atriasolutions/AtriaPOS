import 'package:core/api/api.dart';
import 'package:flutter/material.dart';

import '../di/pos_composition.dart';

class DteQueueScreen extends StatefulWidget {
  const DteQueueScreen({super.key, required this.composition});

  final PosComposition composition;

  @override
  State<DteQueueScreen> createState() => _DteQueueScreenState();
}

class _DteQueueScreenState extends State<DteQueueScreen> {
  List<DteQueueEntryResponse> _items = [];
  bool _loading = true;
  bool _retrying = false;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    setState(() => _loading = true);
    final result = await widget.composition.dteService.listQueue(widget.composition.requireStoreId);
    if (!mounted) return;
    switch (result) {
      case ApiSuccess<DteQueueListResponse>(data: final data):
        setState(() {
          _items = data.items;
          _loading = false;
        });
      case ApiFailure<DteQueueListResponse>():
        setState(() => _loading = false);
    }
  }

  Future<void> _retry() async {
    setState(() => _retrying = true);
    final result = await widget.composition.dteService.retryQueue(widget.composition.requireStoreId);
    if (!mounted) return;
    setState(() => _retrying = false);
    switch (result) {
      case ApiSuccess<DteRetryResponse>(data: final data):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            key: const Key('dte_retry_snackbar'),
            content: Text(
              'Procesadas: ${data.processed}. Fallidas: ${data.failed}.',
            ),
          ),
        );
        await _refresh();
      case ApiFailure<DteRetryResponse>(error: final e):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cola DTE')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? const Center(child: Text('No hay boletas pendientes.'))
              : ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return ListTile(
                      key: Key('dte_queue_tile_${item.saleId}'),
                      title: Text('Venta ${item.saleId}'),
                      subtitle: Text(
                        'Intentos: ${item.attempts}\n'
                        '${item.lastError ?? "Sin detalle"}',
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('dte_retry_button'),
        onPressed: _retrying || _items.isEmpty ? null : _retry,
        label: _retrying
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Text('Reintentar'),
        icon: const Icon(Icons.refresh),
      ),
    );
  }
}