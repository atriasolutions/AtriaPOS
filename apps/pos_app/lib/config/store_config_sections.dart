import 'package:core/api/api.dart';
import 'package:core/domain/domain.dart';
import 'package:flutter/material.dart';

enum StoreConfigSection { ventas, inventario, fiscal }

const _sectionOrder = <StoreConfigSection>[
  StoreConfigSection.ventas,
  StoreConfigSection.inventario,
  StoreConfigSection.fiscal,
];

String storeConfigSectionTitle(StoreConfigSection section) {
  return switch (section) {
    StoreConfigSection.ventas => 'Ventas y cobro',
    StoreConfigSection.inventario => 'Inventario y recepción',
    StoreConfigSection.fiscal => 'Fiscal y cumplimiento',
  };
}

String templateDisplayName(String? templateId) {
  if (templateId == null || templateId.isEmpty) return '';
  return PosTemplateRegistry.resolve(
    PosTemplateId.normalize(templateId),
  ).displayName;
}

class StoreConfigToggleDef {
  const StoreConfigToggleDef({
    required this.key,
    required this.section,
    required this.title,
    required this.subtitle,
    required this.feature,
    required this.patch,
    required this.overrideValue,
  });

  final Key key;
  final StoreConfigSection section;
  final String title;
  final String subtitle;
  final String feature;
  final PatchStoreOperationalConfigRequest Function(bool value) patch;
  final bool? Function(StoreOperationalOverridesDto? overrides) overrideValue;
}

final storeConfigToggleDefs = <StoreConfigToggleDef>[
  StoreConfigToggleDef(
    key: Key('store_config_seller_code'),
    section: StoreConfigSection.ventas,
    title: 'Código vendedor en cobro',
    subtitle: 'Exige colaborador de planilla al confirmar venta.',
    feature: 'sellerCodeCheckout',
    patch: _sellerPatch,
    overrideValue: _sellerOverride,
  ),
  StoreConfigToggleDef(
    key: Key('store_config_invoice'),
    section: StoreConfigSection.ventas,
    title: 'Factura en cobro',
    subtitle: 'Permite emitir factura desde el checkout.',
    feature: 'invoiceCheckout',
    patch: _invoicePatch,
    overrideValue: _invoiceOverride,
  ),
  StoreConfigToggleDef(
    key: Key('store_config_transbank'),
    section: StoreConfigSection.ventas,
    title: 'Pago integrado con tarjeta',
    subtitle:
        'Prepara integración con terminal (p. ej. Transbank). '
        'No afecta el registro manual de débito/crédito en cobro.',
    feature: 'transbankIntegration',
    patch: _transbankPatch,
    overrideValue: _transbankOverride,
  ),
  StoreConfigToggleDef(
    key: Key('store_config_guia_lote'),
    section: StoreConfigSection.inventario,
    title: 'Guía y lote en ingreso',
    subtitle:
        'Exige referencia de guía y lote al ingresar existencias.',
    feature: 'stockReceiptGuiaLote',
    patch: _guiaPatch,
    overrideValue: _guiaOverride,
  ),
  StoreConfigToggleDef(
    key: Key('store_config_expiry'),
    section: StoreConfigSection.inventario,
    title: 'Fecha caducidad en ingreso',
    subtitle: 'Exige fecha de caducidad del lote al ingresar.',
    feature: 'trackExpiryOnReceipt',
    patch: _expiryPatch,
    overrideValue: _expiryOverride,
  ),
  StoreConfigToggleDef(
    key: Key('store_config_inventory_close'),
    section: StoreConfigSection.inventario,
    title: 'Cierre de inventario',
    subtitle: 'Muestra cierre de inventario en el menú.',
    feature: 'inventoryClose',
    patch: _inventoryClosePatch,
    overrideValue: _inventoryCloseOverride,
  ),
  StoreConfigToggleDef(
    key: Key('store_config_dte'),
    section: StoreConfigSection.fiscal,
    title: 'DTE / certificado SII',
    subtitle: 'Cola DTE y estado de certificado en menú.',
    feature: 'dteQueue',
    patch: _dtePatch,
    overrideValue: _dteOverride,
  ),
];

Map<StoreConfigSection, List<StoreConfigToggleDef>> groupStoreConfigToggles() {
  final grouped = <StoreConfigSection, List<StoreConfigToggleDef>>{};
  for (final def in storeConfigToggleDefs) {
    grouped.putIfAbsent(def.section, () => []).add(def);
  }
  return {
    for (final section in _sectionOrder)
      if (grouped[section] != null) section: grouped[section]!,
  };
}

PatchStoreOperationalConfigRequest _sellerPatch(bool v) =>
    PatchStoreOperationalConfigRequest(sellerCodeRequired: v);

PatchStoreOperationalConfigRequest _invoicePatch(bool v) =>
    PatchStoreOperationalConfigRequest(invoiceCheckoutEnabled: v);

PatchStoreOperationalConfigRequest _transbankPatch(bool v) =>
    PatchStoreOperationalConfigRequest(transbankEnabled: v);

PatchStoreOperationalConfigRequest _guiaPatch(bool v) =>
    PatchStoreOperationalConfigRequest(receiptRequiresGuiaLote: v);

PatchStoreOperationalConfigRequest _expiryPatch(bool v) =>
    PatchStoreOperationalConfigRequest(trackExpiryOnReceipt: v);

PatchStoreOperationalConfigRequest _inventoryClosePatch(bool v) =>
    PatchStoreOperationalConfigRequest(inventoryCloseEnabled: v);

PatchStoreOperationalConfigRequest _dtePatch(bool v) =>
    PatchStoreOperationalConfigRequest(dteEnabled: v);

bool? _sellerOverride(StoreOperationalOverridesDto? o) => o?.sellerCodeRequired;
bool? _invoiceOverride(StoreOperationalOverridesDto? o) =>
    o?.invoiceCheckoutEnabled;
bool? _transbankOverride(StoreOperationalOverridesDto? o) => o?.transbankEnabled;
bool? _guiaOverride(StoreOperationalOverridesDto? o) =>
    o?.receiptRequiresGuiaLote;
bool? _expiryOverride(StoreOperationalOverridesDto? o) =>
    o?.trackExpiryOnReceipt;
bool? _inventoryCloseOverride(StoreOperationalOverridesDto? o) =>
    o?.inventoryCloseEnabled;
bool? _dteOverride(StoreOperationalOverridesDto? o) => o?.dteEnabled;