import 'sii_transport.dart';

enum FakeSiiTransportMode { success, timeout, rechazada }

/// Transporte sin red para TDD de `SiiLiveDteGateway`.
class FakeSiiTransport implements SiiTransport {
  FakeSiiTransport({this.mode = FakeSiiTransportMode.success});

  FakeSiiTransportMode mode;
  int callCount = 0;

  @override
  Future<SiiTransportResponse> sendSignedDte(
    String signedXml, {
    required int tipoDte,
    required int folio,
  }) async {
    callCount++;
    return switch (mode) {
      FakeSiiTransportMode.success => SiiTransportResponse(
          outcome: SiiTransportOutcome.emitida,
          trackId: 'FAKE-$folio',
        ),
      FakeSiiTransportMode.timeout => const SiiTransportResponse(
          outcome: SiiTransportOutcome.timeout,
          rejectionDetail: 'Timeout SII (fake transport)',
        ),
      FakeSiiTransportMode.rechazada => const SiiTransportResponse(
          outcome: SiiTransportOutcome.rechazada,
          rejectionDetail: 'Rechazo SII (fake transport)',
        ),
    };
  }
}