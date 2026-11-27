import 'dart:async';

import 'package:core/api/api.dart';
import 'package:core/domain/domain.dart';
import 'package:flutter/material.dart';

import '../di/pos_composition.dart';

class CheckoutPanel extends StatefulWidget {
  const CheckoutPanel({
    super.key,
    required this.composition,
    required this.cartId,
    required this.totalClp,
    required this.enabled,
    required this.requiresSellerCode,
    required this.allowsInvoiceCheckout,
    this.allowsCardPayments = true,
    required this.onSuccess,
  });

  final PosComposition composition;
  final String? cartId;
  final int totalClp;
  final bool enabled;
  final bool requiresSellerCode;
  final bool allowsInvoiceCheckout;
  final bool allowsCardPayments;
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
  bool _invoiceSelected = false;
  final _invoiceRutController = TextEditingController();
  final _invoiceNameController = TextEditingController();
  final _invoiceGiroController = TextEditingController();
  final _invoiceEmailController = TextEditingController();
  final _invoiceAddressController = TextEditingController();
  final _invoiceCityController = TextEditingController();
  final _invoiceCommuneController = TextEditingController();
  final _invoicePhoneController = TextEditingController();
  final _rutFocus = FocusNode();
  PaymentMethod? _paymentMethod;
  final _cashReceivedController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.requiresSellerCode) {
      _loadActiveCollaborators();
    } else {
      _loadingCollaborators = false;
    }
    _sellerCodeController.addListener(_onManualCodeChanged);
    _invoiceRutController.addListener(_onInvoiceFieldsChanged);
    _invoiceNameController.addListener(_onInvoiceFieldsChanged);
    _invoiceGiroController.addListener(_onInvoiceFieldsChanged);
    _invoiceEmailController.addListener(_onInvoiceFieldsChanged);
    _invoiceAddressController.addListener(_onInvoiceFieldsChanged);
    _invoiceCityController.addListener(_onInvoiceFieldsChanged);
    _invoiceCommuneController.addListener(_onInvoiceFieldsChanged);
    _invoicePhoneController.addListener(_onInvoiceFieldsChanged);
    _cashReceivedController.addListener(_onInvoiceFieldsChanged);
    _rutFocus.addListener(() {
      if (!_rutFocus.hasFocus) {
        unawaited(_lookupCustomer());
      }
    });
  }

  Future<void> _lookupCustomer() async {
    final found = await widget.composition.saleService.findInvoiceCustomer(
      widget.composition.requireStoreId,
      _invoiceRutController.text,
    );
    if (!mounted || found == null) return;
    setState(() {
      _invoiceNameController.text = found.businessName;
      _invoiceGiroController.text = found.giro;
      _invoiceEmailController.text = found.email;
      _invoiceAddressController.text = found.address;
      _invoiceCityController.text = found.city;
      _invoiceCommuneController.text = found.commune;
      _invoicePhoneController.text = found.phone;
    });
  }

  void _onInvoiceFieldsChanged() {
    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(covariant CheckoutPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.requiresSellerCode != widget.requiresSellerCode) {
      if (widget.requiresSellerCode) {
        _loadActiveCollaborators();
      } else {
        setState(() {
          _loadingCollaborators = false;
          _loadError = null;
          _active = [];
          _selectedSellerCode = null;
        });
      }
    }
  }

  @override
  void dispose() {
    _sellerCodeController.removeListener(_onManualCodeChanged);
    _sellerCodeController.dispose();
    _invoiceRutController.removeListener(_onInvoiceFieldsChanged);
    _invoiceNameController.removeListener(_onInvoiceFieldsChanged);
    _invoiceRutController.dispose();
    _invoiceNameController.dispose();
    _invoiceGiroController.dispose();
    _invoiceEmailController.dispose();
    _invoiceAddressController.dispose();
    _invoiceCityController.dispose();
    _invoiceCommuneController.dispose();
    _invoicePhoneController.dispose();
    _rutFocus.dispose();
    _cashReceivedController.dispose();
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

  bool get _invoiceReady {
    if (!_invoiceSelected) return true;
    return _invoiceRutController.text.trim().isNotEmpty &&
        _invoiceNameController.text.trim().isNotEmpty &&
        _invoiceGiroController.text.trim().isNotEmpty &&
        _invoiceEmailController.text.trim().isNotEmpty &&
        _invoiceAddressController.text.trim().isNotEmpty &&
        _invoiceCityController.text.trim().isNotEmpty &&
        _invoiceCommuneController.text.trim().isNotEmpty &&
        _invoicePhoneController.text.trim().isNotEmpty;
  }

  bool get _paymentsEnabled => widget.enabled && _invoiceReady && !_confirming;

  int? get _cashReceivedClp {
    final digits = _cashReceivedController.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return null;
    return int.tryParse(digits);
  }

  bool get _canConfirm {
    if (!widget.enabled || widget.cartId == null || _confirming) {
      return false;
    }
    if (widget.requiresSellerCode) {
      if (_loadingCollaborators) return false;
      if ((_effectiveSellerCode ?? '').isEmpty) return false;
    }
    if (!_invoiceReady) return false;
    final method = _paymentMethod;
    if (method == null) return false;
    if (method == PaymentMethod.efectivo) {
      final received = _cashReceivedClp;
      if (received == null || received < widget.totalClp) return false;
    }
    return true;
  }

  Future<void> _confirm() async {
    final cartId = widget.cartId;
    if (cartId == null) return;
    final sellerCode = widget.requiresSellerCode
        ? _effectiveSellerCode
        : '';
    if (widget.requiresSellerCode &&
        (sellerCode == null || sellerCode.isEmpty)) {
      return;
    }
    final method = _paymentMethod;
    if (method == null) return;
    final received = _cashReceivedClp;
    if (method == PaymentMethod.efectivo &&
        (received == null || received < widget.totalClp)) {
      return;
    }

    setState(() => _confirming = true);
    final isCash = method == PaymentMethod.efectivo;
    final amountClp = isCash ? received! : widget.totalClp;
    final changeClp = isCash ? amountClp - widget.totalClp : 0;
    final documentType = _invoiceSelected ? 'FACTURA' : 'BOLETA';
    final invoiceReceiver = _invoiceSelected
        ? CheckoutInvoiceReceiverDto(
            rut: _invoiceRutController.text.trim(),
            businessName: _invoiceNameController.text.trim(),
            giro: _invoiceGiroController.text.trim(),
            email: _invoiceEmailController.text.trim(),
            address: _invoiceAddressController.text.trim(),
            city: _invoiceCityController.text.trim(),
            commune: _invoiceCommuneController.text.trim(),
            phone: _invoicePhoneController.text.trim(),
          )
        : null;
    final result = await widget.composition.saleService.checkout(
      widget.composition.requireStoreId,
      cartId,
      CheckoutRequest(
        sellerCode: sellerCode ?? '',
        payments: [
          CheckoutPaymentDto(
            method: method.apiValue,
            amountClp: amountClp,
          ),
        ],
        changeClp: changeClp,
        documentType: documentType,
        invoiceReceiver: invoiceReceiver,
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
        Expanded(
          child: SingleChildScrollView(
            child: Column(
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
        if (widget.allowsInvoiceCheckout) ...[
          const SizedBox(height: 16),
          Text('Documento', style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(
                value: false,
                label: Text('Boleta'),
                icon: Icon(Icons.receipt_long_outlined),
              ),
              ButtonSegment(
                value: true,
                label: Text('Factura'),
                icon: Icon(Icons.description_outlined),
              ),
            ],
            selected: {_invoiceSelected},
            onSelectionChanged: widget.enabled
                ? (selection) {
                    setState(() {
                      _invoiceSelected = selection.first;
                    });
                  }
                : null,
            style: ButtonStyle(
              minimumSize: WidgetStateProperty.all(const Size(0, 56)),
            ),
            showSelectedIcon: false,
            key: const Key('checkout_document_type_segment'),
          ),
          if (_invoiceSelected) ...[
            const SizedBox(height: 12),
            TextField(
              key: const Key('checkout_invoice_rut'),
              controller: _invoiceRutController,
              focusNode: _rutFocus,
              enabled: widget.enabled,
              decoration: const InputDecoration(
                labelText: 'RUT receptor',
              ),
              textCapitalization: TextCapitalization.characters,
              onChanged: (value) {
                final formatted = RutChile.formatAsUserTypes(value);
                if (formatted != value) {
                  _invoiceRutController.value = TextEditingValue(
                    text: formatted,
                    selection:
                        TextSelection.collapsed(offset: formatted.length),
                  );
                }
              },
            ),
            const SizedBox(height: 8),
            TextField(
              key: const Key('checkout_invoice_business_name'),
              controller: _invoiceNameController,
              enabled: widget.enabled,
              decoration: const InputDecoration(
                labelText: 'Razón social receptor',
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 8),
            TextField(
              key: const Key('checkout_invoice_giro'),
              controller: _invoiceGiroController,
              enabled: widget.enabled,
              decoration: const InputDecoration(labelText: 'Giro empresa'),
            ),
            const SizedBox(height: 8),
            TextField(
              key: const Key('checkout_invoice_email'),
              controller: _invoiceEmailController,
              enabled: widget.enabled,
              decoration: const InputDecoration(labelText: 'Correo electrónico'),
            ),
            const SizedBox(height: 8),
            TextField(
              key: const Key('checkout_invoice_address'),
              controller: _invoiceAddressController,
              enabled: widget.enabled,
              decoration: const InputDecoration(labelText: 'Dirección'),
            ),
            const SizedBox(height: 8),
            TextField(
              key: const Key('checkout_invoice_city'),
              controller: _invoiceCityController,
              enabled: widget.enabled,
              decoration: const InputDecoration(labelText: 'Ciudad'),
            ),
            const SizedBox(height: 8),
            TextField(
              key: const Key('checkout_invoice_commune'),
              controller: _invoiceCommuneController,
              enabled: widget.enabled,
              decoration: const InputDecoration(labelText: 'Comuna'),
            ),
            const SizedBox(height: 8),
            TextField(
              key: const Key('checkout_invoice_phone'),
              controller: _invoicePhoneController,
              enabled: widget.enabled,
              decoration: const InputDecoration(labelText: 'Contacto (teléfono)'),
            ),
          ],
        ],
        const SizedBox(height: 16),
        Text('Medio de pago', style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        Row(
          children: [
            _paymentButton('Efectivo', PaymentMethod.efectivo, const Key('checkout_pay_efectivo')),
            if (widget.allowsCardPayments) ...[
              _paymentButton('Débito', PaymentMethod.debito, const Key('checkout_pay_debito')),
              _paymentButton('Crédito', PaymentMethod.credito, const Key('checkout_pay_credito')),
            ],
          ],
        ),
        if (_paymentMethod == PaymentMethod.efectivo) ...[
          const SizedBox(height: 12),
          TextField(
            key: const Key('checkout_cash_received'),
            controller: _cashReceivedController,
            enabled: _paymentsEnabled,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Monto recibido',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _cashStatusLabel,
            key: const Key('checkout_change_label'),
            style: theme.textTheme.titleMedium,
          ),
        ],
        if (widget.requiresSellerCode) ...[
          const SizedBox(height: 16),
          const Text('Vendedor'),
        ],
        if (widget.requiresSellerCode && _loadingCollaborators)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (widget.requiresSellerCode && _loadError != null)
          Text(_loadError!)
        else if (widget.requiresSellerCode && _active.isEmpty)
          const Text('No hay colaboradores activos. Configure la planilla.')
        else if (widget.requiresSellerCode) ...[
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
            ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        FilledButton(
          key: const Key('confirm_checkout_button'),
          onPressed: _canConfirm ? _confirm : null,
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(56),
          ),
          child: _confirming
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Cobrar'),
        ),
      ],
    );
  }

  String get _cashStatusLabel {
    final received = _cashReceivedClp;
    if (received == null) return 'Vuelto: —';
    final delta = received - widget.totalClp;
    if (delta < 0) return 'Falta: \$${-delta}';
    return 'Vuelto: \$$delta';
  }

  IconData _paymentIcon(PaymentMethod method) {
    return switch (method) {
      PaymentMethod.efectivo => Icons.payments_outlined,
      PaymentMethod.debito => Icons.credit_card,
      PaymentMethod.credito => Icons.account_balance_wallet_outlined,
      PaymentMethod.otro => Icons.more_horiz,
    };
  }

  static const _cashGreen = Color(0xFF2E7D32);
  static const _debitYellow = Color(0xFFF9A825);
  static const _creditPurple = Color(0xFF5B4FCF);

  Color _paymentAccentColor(ColorScheme cs, PaymentMethod method) {
    return switch (method) {
      PaymentMethod.efectivo => _cashGreen,
      PaymentMethod.debito => _debitYellow,
      PaymentMethod.credito => _creditPurple,
      PaymentMethod.otro => cs.onSurfaceVariant,
    };
  }

  Color _paymentIconColor(ColorScheme cs, PaymentMethod method, bool selected) {
    if (selected) return cs.onPrimary;
    return _paymentAccentColor(cs, method);
  }

  Widget _paymentButton(String label, PaymentMethod method, Key key) {
    final selected = _paymentMethod == method;
    final cs = Theme.of(context).colorScheme;
    final iconColor = _paymentIconColor(cs, method, selected);
    final labelColor = selected ? cs.onPrimary : cs.onSurfaceVariant;
    final accent = _paymentAccentColor(cs, method);

    Widget iconChild = Icon(_paymentIcon(method), size: 22, color: iconColor);
    if (!selected) {
      iconChild = DecoratedBox(
        decoration: BoxDecoration(
          color: accent.withValues(alpha: 0.12),
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: iconChild,
        ),
      );
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: FilledButton(
          key: key,
          onPressed: _paymentsEnabled
              ? () => setState(() => _paymentMethod = method)
              : null,
          style: FilledButton.styleFrom(
            minimumSize: const Size(0, 56),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            backgroundColor:
                selected ? cs.primary : cs.surfaceContainerHighest,
            foregroundColor: labelColor,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              iconChild,
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(fontSize: 13, color: labelColor),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}