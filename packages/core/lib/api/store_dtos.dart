class BootstrapStoreRequest {
  const BootstrapStoreRequest({
    required this.rut,
    required this.legalName,
    required this.businessLine,
    required this.ownerDisplayName,
    required this.ownerPin,
  });

  final String rut;
  final String legalName;
  final String businessLine;
  final String ownerDisplayName;
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