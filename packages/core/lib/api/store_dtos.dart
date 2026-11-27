class BootstrapStoreRequest {
  const BootstrapStoreRequest({
    required this.rut,
    required this.legalName,
    required this.businessLine,
    required this.ownerFirstName,
    required this.ownerLastName,
    required this.ownerUsername,
    required this.ownerRut,
    required this.ownerPin,
  });

  final String rut;
  final String legalName;
  final String businessLine;
  final String ownerFirstName;
  final String ownerLastName;
  final String ownerUsername;
  final String ownerRut;
  final String ownerPin;
}

class BootstrapStoreResponse {
  const BootstrapStoreResponse({
    required this.storeId,
    required this.userId,
    required this.token,
    required this.role,
    required this.expiresAt,
  });

  final String storeId;
  final String userId;
  final String token;
  final String role;
  final String expiresAt;
}

class ActiveStoreResponse {
  const ActiveStoreResponse({
    required this.storeId,
    required this.rut,
    required this.legalName,
    required this.businessLine,
    required this.taxConfig,
  });

  final String storeId;
  final String rut;
  final String legalName;
  final String businessLine;
  final Map<String, dynamic> taxConfig;
}

class PosTemplateResponse {
  const PosTemplateResponse({
    required this.templateId,
    required this.displayName,
    required this.features,
  });

  final String templateId;
  final String displayName;
  final List<String> features;
}

class StoreOperationalOverridesDto {
  const StoreOperationalOverridesDto({
    this.sellerCodeRequired,
    this.invoiceCheckoutEnabled,
    this.transbankEnabled,
    this.receiptRequiresGuiaLote,
    this.trackExpiryOnReceipt,
    this.inventoryCloseEnabled,
    this.dteEnabled,
  });

  final bool? sellerCodeRequired;
  final bool? invoiceCheckoutEnabled;
  final bool? transbankEnabled;
  final bool? receiptRequiresGuiaLote;
  final bool? trackExpiryOnReceipt;
  final bool? inventoryCloseEnabled;
  final bool? dteEnabled;
}

class StoreOperationalConfigResponse {
  const StoreOperationalConfigResponse({
    required this.schemaVersion,
    required this.templateId,
    required this.overrides,
    required this.effectiveFeatures,
  });

  final int schemaVersion;
  final String templateId;
  final StoreOperationalOverridesDto overrides;
  final List<String> effectiveFeatures;
}

class PatchStoreOperationalConfigRequest {
  const PatchStoreOperationalConfigRequest({
    this.sellerCodeRequired,
    this.invoiceCheckoutEnabled,
    this.transbankEnabled,
    this.receiptRequiresGuiaLote,
    this.trackExpiryOnReceipt,
    this.inventoryCloseEnabled,
    this.dteEnabled,
  });

  final bool? sellerCodeRequired;
  final bool? invoiceCheckoutEnabled;
  final bool? transbankEnabled;
  final bool? receiptRequiresGuiaLote;
  final bool? trackExpiryOnReceipt;
  final bool? inventoryCloseEnabled;
  final bool? dteEnabled;
}