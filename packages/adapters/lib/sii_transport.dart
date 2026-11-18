enum SiiTransportOutcome {
  emitida,
  rechazada,
  timeout,
}

class SiiTransportResponse {
  const SiiTransportResponse({
    required this.outcome,
    this.trackId,
    this.rejectionDetail,
  });

  final SiiTransportOutcome outcome;
  final String? trackId;
  final String? rejectionDetail;
}

abstract class SiiTransport {
  Future<SiiTransportResponse> sendSignedDte(
    String signedXml, {
    required int tipoDte,
    required int folio,
  });
}