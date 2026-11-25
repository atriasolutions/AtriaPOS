class CreateCompanionPairingOfferResponse {
  const CreateCompanionPairingOfferResponse({
    required this.pairingCode,
    required this.mode,
    required this.expiresAt,
  });

  final String pairingCode;
  final String mode;
  final String expiresAt;
}

class CompanionPairRequest {
  const CompanionPairRequest({
    required this.pairingCode,
    required this.mode,
  });

  final String pairingCode;
  final String mode;
}

class CompanionPairResponse {
  const CompanionPairResponse({
    required this.token,
    required this.expiresAt,
    required this.wsPath,
    required this.mode,
  });

  final String token;
  final String expiresAt;
  final String wsPath;
  final String mode;
}