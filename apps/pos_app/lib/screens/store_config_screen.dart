import 'dart:async';

import 'package:core/api/api.dart';
import 'package:flutter/material.dart';

import '../di/pos_composition.dart';
import '../theme/atria_touch_targets.dart';

class StoreConfigScreen extends StatefulWidget {
  const StoreConfigScreen({super.key, required this.composition});

  final PosComposition composition;

  @override
  State<StoreConfigScreen> createState() => _StoreConfigScreenState();
}

class _StoreConfigScreenState extends State<StoreConfigScreen> {
  StoreOperationalConfigResponse? _config;
  String? _error;
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await widget.composition.storeService.getStoreOperationalConfig(
      widget.composition.requireStoreId,
    );
    if (!mounted) return;
    switch (result) {
      case ApiSuccess<StoreOperationalConfigResponse>(data: final data):
        setState(() {
          _config = data;
          _loading = false;
        });
      case ApiFailure<StoreOperationalConfigResponse>(error: final e):
        setState(() {
          _error = e.message;
          _loading = false;
        });
    }
  }

  Future<void> _patch(PatchStoreOperationalConfigRequest patch) async {
    setState(() => _saving = true);
    final result = await widget.composition.storeService.patchStoreOperationalConfig(
      widget.composition.requireStoreId,
      patch,
    );
    if (!mounted) return;
    setState(() => _saving = false);
    switch (result) {
      case ApiSuccess<StoreOperationalConfigResponse>(data: final data):
        setState(() => _config = data);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Configuración guardada')),
        );
      case ApiFailure<StoreOperationalConfigResponse>(error: final e):
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
    }
  }

  bool _flag(String feature) =>
      _config?.effectiveFeatures.contains(feature) ?? false;

  Widget _toggle({
    required Key key,
    required String title,
    required String subtitle,
    required bool value,
    required Future<void> Function(bool) onChanged,
  }) {
    return SwitchListTile(
      key: key,
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: _saving
          ? null
          : (next) async {
              await onChanged(next);
            },
    );
  }

  @override
  Widget build(BuildContext context) {
    final o = _config?.overrides;
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración de tienda')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(
                      'Plantilla base: ${_config?.templateId ?? ''}',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    ...[
                      (
                        key: const Key('store_config_seller_code'),
                        title: 'Código vendedor en cobro',
                        subtitle:
                            'Exige colaborador de planilla al confirmar venta.',
                        feature: 'sellerCodeCheckout',
                        patch: (bool v) => PatchStoreOperationalConfigRequest(
                          sellerCodeRequired: v,
                        ),
                        override: o?.sellerCodeRequired,
                      ),
                      (
                        key: const Key('store_config_invoice'),
                        title: 'Factura en cobro',
                        subtitle: 'Permite emitir factura desde el checkout.',
                        feature: 'invoiceCheckout',
                        patch: (bool v) => PatchStoreOperationalConfigRequest(
                          invoiceCheckoutEnabled: v,
                        ),
                        override: o?.invoiceCheckoutEnabled,
                      ),
                      (
                        key: const Key('store_config_transbank'),
                        title: 'Pagos con tarjeta (Transbank)',
                        subtitle:
                            'Habilita débito y crédito en cobro (sin terminal conectada).',
                        feature: 'transbankIntegration',
                        patch: (bool v) => PatchStoreOperationalConfigRequest(
                          transbankEnabled: v,
                        ),
                        override: o?.transbankEnabled,
                      ),
                      (
                        key: const Key('store_config_guia_lote'),
                        title: 'Guía y lote en ingreso',
                        subtitle:
                            'Exige referencia de guía y lote al ingresar existencias.',
                        feature: 'stockReceiptGuiaLote',
                        patch: (bool v) => PatchStoreOperationalConfigRequest(
                          receiptRequiresGuiaLote: v,
                        ),
                        override: o?.receiptRequiresGuiaLote,
                      ),
                      (
                        key: const Key('store_config_expiry'),
                        title: 'Fecha caducidad en ingreso',
                        subtitle:
                            'Exige fecha de caducidad del lote al ingresar.',
                        feature: 'trackExpiryOnReceipt',
                        patch: (bool v) => PatchStoreOperationalConfigRequest(
                          trackExpiryOnReceipt: v,
                        ),
                        override: o?.trackExpiryOnReceipt,
                      ),
                      (
                        key: const Key('store_config_inventory_close'),
                        title: 'Cierre de inventario',
                        subtitle: 'Muestra cierre de inventario en el menú.',
                        feature: 'inventoryClose',
                        patch: (bool v) => PatchStoreOperationalConfigRequest(
                          inventoryCloseEnabled: v,
                        ),
                        override: o?.inventoryCloseEnabled,
                      ),
                      (
                        key: const Key('store_config_dte'),
                        title: 'DTE / certificado SII',
                        subtitle: 'Cola DTE y estado de certificado en menú.',
                        feature: 'dteQueue',
                        patch: (bool v) => PatchStoreOperationalConfigRequest(
                          dteEnabled: v,
                        ),
                        override: o?.dteEnabled,
                      ),
                    ].map((def) {
                      return SizedBox(
                        height: kMinTouchHeight * 2.2,
                        child: _toggle(
                          key: def.key,
                          title: def.title,
                          subtitle: def.subtitle,
                          value: _flag(def.feature),
                          onChanged: (next) => _patch(def.patch(next)),
                        ),
                      );
                    }),
                  ],
                ),
    );
  }
}