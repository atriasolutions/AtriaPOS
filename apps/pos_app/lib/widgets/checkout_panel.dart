import 'package:core/api/api.dart';
import 'package:flutter/material.dart';

import '../di/pos_composition.dart';

class CheckoutPanel extends StatefulWidget {
  const CheckoutPanel({
    super.key,
    required this.composition,
    required this.cartId,
    required this.totalClp,
    required this.enabled,
    required this.onSuccess,
  });

  final PosComposition composition;
  final String? cartId;
  final int totalClp;
  final bool enabled;
  final Future<void> Function(CheckoutResponse response) onSuccess;

  @override
  State<CheckoutPanel> createState() => _CheckoutPanelState();
}

class _CheckoutPanelState extends State<CheckoutPanel> {
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
      widget.enabled &&
      widget.cartId != null &&
      !_loadingCollaborators &&
      !_confirming &&
      (_effectiveSellerCode ?? '').isNotEmpty;

  Future<void> _confirm() async {
    final sellerCode = _effectiveSellerCode;
    final cartId = widget.cartId;
    if (sellerCode == null || sellerCode.isEmpty || cartId == null) return;

    setState(() => _confirming = true);
    final result = await widget.composition.saleService.checkout(
      widget.composition.requireStoreId,
      cartId,
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
        await widget.onSuccess(data);
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
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Realizar pago',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: cs.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Text(
                'Total',
                style: theme.textTheme.titleMedium,
              ),
              const Spacer(),
              Text(
                key: const Key('cart_total_label'),
                '\$${widget.totalClp}',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Pago: efectivo por el total exacto.',
          style: theme.textTheme.bodySmall,
        ),
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
          const Text('No hay colaboradores activos. Configure la planilla.')
        else ...[
          DropdownButtonFormField<String>(
            key: const Key('checkout_seller_dropdown'),
            value: _selectedSellerCode,
            decoration: const InputDecoration(
              labelText: 'Seleccionar vendedor',
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
            onChanged: widget.enabled
                ? (value) {
                    setState(() {
                      _selectedSellerCode = value;
                      _sellerCodeController.clear();
                    });
                  }
                : null,
          ),
          const SizedBox(height: 12),
          TextField(
            key: const Key('checkout_seller_code_field'),
            controller: _sellerCodeController,
            enabled: widget.enabled,
            decoration: const InputDecoration(
              labelText: 'O ingrese código',
            ),
            textCapitalization: TextCapitalization.characters,
          ),
        ],
        const Spacer(),
        FilledButton(
          key: const Key('confirm_checkout_button'),
          onPressed: _canConfirm ? _confirm : null,
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            backgroundColor: widget.enabled
                ? cs.primary
                : Colors.grey.shade400,
          ),
          child: _confirming
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('FINALIZAR / COBRAR'),
        ),
      ],
    );
  }
}