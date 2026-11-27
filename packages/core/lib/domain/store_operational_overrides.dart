import 'dart:convert';

import 'failures.dart';

/// Overrides por tienda (RF-099). `null` = sin cambio respecto a plantilla.
class StoreOperationalOverrides {
  const StoreOperationalOverrides({
  this.schemaVersion = currentSchemaVersion,
    this.sellerCodeRequired,
    this.invoiceCheckoutEnabled,
    this.transbankEnabled,
    this.receiptRequiresGuiaLote,
    this.trackExpiryOnReceipt,
    this.inventoryCloseEnabled,
    this.dteEnabled,
  });

  static const int currentSchemaVersion = 1;

  final int schemaVersion;
  final bool? sellerCodeRequired;
  final bool? invoiceCheckoutEnabled;
  final bool? transbankEnabled;
  final bool? receiptRequiresGuiaLote;
  final bool? trackExpiryOnReceipt;
  final bool? inventoryCloseEnabled;
  final bool? dteEnabled;

  static const StoreOperationalOverrides empty = StoreOperationalOverrides();

  StoreOperationalOverrides merge(StoreOperationalOverrides patch) {
    return StoreOperationalOverrides(
      schemaVersion: currentSchemaVersion,
      sellerCodeRequired: patch.sellerCodeRequired ?? sellerCodeRequired,
      invoiceCheckoutEnabled:
          patch.invoiceCheckoutEnabled ?? invoiceCheckoutEnabled,
      transbankEnabled: patch.transbankEnabled ?? transbankEnabled,
      receiptRequiresGuiaLote:
          patch.receiptRequiresGuiaLote ?? receiptRequiresGuiaLote,
      trackExpiryOnReceipt: patch.trackExpiryOnReceipt ?? trackExpiryOnReceipt,
      inventoryCloseEnabled:
          patch.inventoryCloseEnabled ?? inventoryCloseEnabled,
      dteEnabled: patch.dteEnabled ?? dteEnabled,
    );
  }

  Map<String, Object?> toJson() => {
        'schemaVersion': schemaVersion,
        if (sellerCodeRequired != null) 'sellerCodeRequired': sellerCodeRequired,
        if (invoiceCheckoutEnabled != null)
          'invoiceCheckoutEnabled': invoiceCheckoutEnabled,
        if (transbankEnabled != null) 'transbankEnabled': transbankEnabled,
        if (receiptRequiresGuiaLote != null)
          'receiptRequiresGuiaLote': receiptRequiresGuiaLote,
        if (trackExpiryOnReceipt != null)
          'trackExpiryOnReceipt': trackExpiryOnReceipt,
        if (inventoryCloseEnabled != null)
          'inventoryCloseEnabled': inventoryCloseEnabled,
        if (dteEnabled != null) 'dteEnabled': dteEnabled,
      };

  static StoreOperationalOverrides? parseJsonString(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        throw const ValidationFailure('Configuración operativa inválida');
      }
      return fromJson(decoded);
    } on FormatException {
      throw const ValidationFailure('Configuración operativa inválida');
    }
  }

  static StoreOperationalOverrides fromJson(Map<String, dynamic> json) {
    final version = json['schemaVersion'];
    if (version is! int || version < 1 || version > currentSchemaVersion) {
      throw ValidationFailure(
        'Versión de configuración no soportada: $version',
      );
    }
    bool? readBool(String key) {
      final v = json[key];
      if (v == null) return null;
      if (v is bool) return v;
      throw ValidationFailure('Valor inválido para $key');
    }

    return StoreOperationalOverrides(
      schemaVersion: version,
      sellerCodeRequired: readBool('sellerCodeRequired'),
      invoiceCheckoutEnabled: readBool('invoiceCheckoutEnabled'),
      transbankEnabled: readBool('transbankEnabled'),
      receiptRequiresGuiaLote: readBool('receiptRequiresGuiaLote'),
      trackExpiryOnReceipt: readBool('trackExpiryOnReceipt'),
      inventoryCloseEnabled: readBool('inventoryCloseEnabled'),
      dteEnabled: readBool('dteEnabled'),
    );
  }

  String toJsonString() => jsonEncode(toJson());
}