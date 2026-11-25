class CreateScanSessionRequest {
  const CreateScanSessionRequest({
    required this.kind,
    this.guideRef,
    this.lotRef,
  });

  final String kind;
  final String? guideRef;
  final String? lotRef;
}

class ScanSessionLineDto {
  const ScanSessionLineDto({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.lastScannedAt,
  });

  final String productId;
  final String productName;
  final int quantity;
  final DateTime lastScannedAt;
}

class ScanSessionResponse {
  const ScanSessionResponse({
    required this.sessionId,
    required this.kind,
    required this.state,
    required this.lines,
    this.guideRef,
    this.lotRef,
  });

  final String sessionId;
  final String kind;
  final String state;
  final String? guideRef;
  final String? lotRef;
  final List<ScanSessionLineDto> lines;
}

class RecordScanRequest {
  const RecordScanRequest({required this.code});

  final String code;
}

class ConfirmScanSessionRequest {
  const ConfirmScanSessionRequest({this.idempotencyKey});

  final String? idempotencyKey;
}

class ConfirmScanSessionLineResult {
  const ConfirmScanSessionLineResult({
    required this.productId,
    required this.quantity,
    required this.stock,
    required this.movementId,
  });

  final String productId;
  final int quantity;
  final int stock;
  final String movementId;
}

class ConfirmScanSessionResponse {
  const ConfirmScanSessionResponse({
    required this.sessionId,
    required this.state,
    required this.results,
    this.guideRef,
    this.lotRef,
  });

  final String sessionId;
  final String state;
  final String? guideRef;
  final String? lotRef;
  final List<ConfirmScanSessionLineResult> results;
}