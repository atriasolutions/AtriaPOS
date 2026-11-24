import 'package:core/api/api.dart';
import 'package:flutter/material.dart';

import '../di/pos_composition.dart';

Future<CheckoutResponse?> showCheckoutDialog({
  required BuildContext context,
  required PosComposition composition,
  required String cartId,
  required int totalClp,
}) {
  return showDialog<CheckoutResponse>(
    context: context,
    builder: (ctx) => _CheckoutDialog(
      composition: composition,
      cartId: cartId,
      totalClp: totalClp,
    ),
  );
}

class _CheckoutDialog extends StatefulWidget {
  const _CheckoutDialog({
    required this.composition,
    required this.cartId,
    required this.totalClp,
  });

  final PosComposition composition;
  final String cartId;
  final int totalClp;

  @override
  State<_CheckoutDialog> createState() => _CheckoutDialogState();
}

class _CheckoutDialogState extends State<_CheckoutDialog> {
  bool _loadingCollaborators = true;
  bool _confirming = false;
  String? _loadError;
  List<ActiveCollaboratorResponse> _active = [];
  String? _selectedSellerCode;
  final _sellerCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadActiveCollaborators();
    _sellerCodeController.addListener(_onManualCodeChanged);
  }

  @override
  void dispose() {
    _sellerCodeController.removeListener(_onManualCodeChanged);
    _sellerCodeController.dispose();
    super.dispose();
  }

  void _onManualCodeChanged() {
    if (_sellerCodeController.text.trim().isNotEmpty) {
      setState(() => _selectedSellerCode = null);
    }
    setState(() {});
  }

  Future<void> _loadActiveCollaborators() async {
    final result = await widget.composition.collaboratorService.listActiveForSale(
      widget.composition.requireStoreId,
    );
    if (!mounted) return;
    switch (result) {
      case ApiSuccess<ListActiveCollaboratorsResponse>(data: final data):
        setState(() {
          _active = data.items;
          _loadingCollaborators = false;
          if (_active.length == 1) {
            _selectedSellerCode = _active.first.sellerCode;
          }
        });
      case ApiFailure<ListActiveCollaboratorsResponse>(error: final e):
        setState(() {
          _loadError = e.message;
          _loadingCollaborators = false;
        });
    }
  }

  String? get _effectiveSellerCode {
    final manual = _sellerCodeController.text.trim();
    if (manual.isNotEmpty) return manual;
    return _selectedSellerCode;
  }

  bool get _canConfirm =>
      !_loadingCollaborators &&
      !_confirming &&
      (_effectiveSellerCode ?? '').isNotEmpty;

  Future<void> _confirm() async {
    final sellerCode = _effectiveSellerCode;
    if (sellerCode == null || sellerCode.isEmpty) return;

    setState(() => _confirming = true);
    final result = await widget.composition.saleService.checkout(
      widget.composition.requireStoreId,
      widget.cartId,
      CheckoutRequest(
        sellerCode: sellerCode,
        payments: [
          CheckoutPaymentDto(
            method: 'EFECTIVO',
            amountClp: widget.totalClp,
          ),
        ],
        changeClp: 0,
      ),
    );
    if (!mounted) return;
    setState(() => _confirming = false);
    switch (result) {
      case ApiSuccess<CheckoutResponse>(data: final data):
        Navigator.of(context).pop(data);
      case ApiFailure<CheckoutResponse>(error: final e):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            key: const Key('checkout_validation_snackbar'),
            content: Text(_userMessage(e)),
          ),
        );
    }
  }

  String _userMessage(ApiErrorBody e) {
    return switch (e.code) {
      'TURNO_CERRADO' => 'No hay turno abierto. Abra turno antes de vender.',
      'STOCK_INSUFICIENTE' => e.message,
      'VALIDACION' => e.message,
      _ => e.message,
    };
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Cobrar'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Total: \$${widget.totalClp}'),
            const SizedBox(height: 8),
            const Text('Pago: efectivo por el total exacto.'),
            const SizedBox(height: 16),
            const Text('Vendedor'),
            if (_loadingCollaborators)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_loadError != null)
              Text(_loadError!)
            else if (_active.isEmpty)
              const Text(
                'No hay colaboradores activos. Configure la planilla.',
              )
            else ...[
              DropdownButtonFormField<String>(
                key: const Key('checkout_seller_dropdown'),
                initialValue: _selectedSellerCode,
                decoration: const InputDecoration(
                  labelText: 'Seleccionar vendedor',
                  border: OutlineInputBorder(),
                ),
                items: _active
                    .map(
                      (c) => DropdownMenuItem(
                        value: c.sellerCode,
                        child: Text(
                          '${c.sellerCode} — ${c.firstName} ${c.lastName}',
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSellerCode = value;
                    _sellerCodeController.clear();
                  });
                },
              ),
              const SizedBox(height: 12),
              TextField(
                key: const Key('checkout_seller_code_field'),
                controller: _sellerCodeController,
                decoration: const InputDecoration(
                  labelText: 'O ingrese código',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.characters,
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _confirming ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          key: const Key('confirm_checkout_button'),
          onPressed: _canConfirm ? _confirm : null,
          child: _confirming
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Confirmar venta'),
        ),
      ],
    );
  }
}