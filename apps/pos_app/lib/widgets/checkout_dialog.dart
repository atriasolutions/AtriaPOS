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
  bool _loading = false;

  Future<void> _confirm() async {
    setState(() => _loading = true);
    final result = await widget.composition.saleService.checkout(
      widget.composition.requireStoreId,
      widget.cartId,
      CheckoutRequest(
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
    setState(() => _loading = false);
    switch (result) {
      case ApiSuccess<CheckoutResponse>(data: final data):
        Navigator.of(context).pop(data);
      case ApiFailure<CheckoutResponse>(error: final e):
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_userMessage(e))),
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
      content: Text(
        'Total: \$${widget.totalClp}\nPago: efectivo por el total exacto.',
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          key: const Key('confirm_checkout_button'),
          onPressed: _loading ? null : _confirm,
          child: _loading
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