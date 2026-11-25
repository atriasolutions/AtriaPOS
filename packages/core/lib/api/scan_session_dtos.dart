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