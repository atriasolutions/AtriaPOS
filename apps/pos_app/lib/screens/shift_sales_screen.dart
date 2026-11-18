import 'package:core/api/api.dart';
import 'package:core/domain/domain.dart';
import 'package:flutter/material.dart';

import '../di/pos_composition.dart';

class ShiftSalesScreen extends StatefulWidget {
  const ShiftSalesScreen({super.key, required this.composition});

  final PosComposition composition;

  @override
  State<ShiftSalesScreen> createState() => _ShiftSalesScreenState();
}

class _ShiftSalesScreenState extends State<ShiftSalesScreen> {
  List<ShiftSaleItemResponse> _items = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final result =
        await widget.composition.saleService.listShiftSales(widget.composition.requireStoreId);
    switch (result) {
      case ApiSuccess<ListShiftSalesResponse>(data: final data):
        if (!mounted) return;
        setState(() {
          _items = data.items;
          _loading = false;
        });
      case ApiFailure<ListShiftSalesResponse>(error: final err):
        if (!mounted) return;
        setState(() {
          _error = err.message;
          _loading = false;
        });
    }
  }

  bool _canVoid(ShiftSaleItemResponse item) =>
      item.status == SaleStatus.confirmada.apiValue &&
      item.dteStatus != DteStatus.emitida.apiValue;

  Future<void> _confirmVoid(ShiftSaleItemResponse item) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Anular venta'),
        content: const Text(
          '¿Anular esta venta? Se devolverá el stock.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            key: const Key('void_sale_confirm_button'),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Anular'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;

    final result =
        await widget.composition.saleService.voidSale(widget.composition.requireStoreId, item.saleId);
    if (!mounted) return;
    switch (result) {
      case ApiSuccess<VoidSaleResponse>():
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Venta anulada')),
        );
        await _load();
      case ApiFailure<VoidSaleResponse>(error: final err):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err.message)),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ventas del turno')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : _items.isEmpty
                  ? const Center(child: Text('No hay ventas en este turno'))
                  : ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        final item = _items[index];
                        final folio =
                            item.folio != null ? ' · Folio ${item.folio}' : '';
                        return ListTile(
                          key: Key('shift_sale_tile_${item.saleId}'),
                          title: Text('Total \$${item.totalClp}'),
                          subtitle: Text(
                            '${item.status} · ${item.dteStatus}$folio',
                          ),
                          trailing: _canVoid(item)
                              ? TextButton(
                                  key: Key('void_sale_button_${item.saleId}'),
                                  onPressed: () => _confirmVoid(item),
                                  child: const Text('Anular'),
                                )
                              : null,
                        );
                      },
                    ),
    );
  }
}