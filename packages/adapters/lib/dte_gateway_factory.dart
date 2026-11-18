import 'package:core/pos_barrio_core.dart';

import 'file_certificate_store.dart';
import 'sii_cert_replay_dte_gateway.dart';

enum DteGatewayMode { fake, replay }

DteGatewayMode dteGatewayModeFromEnvironment() {
  const raw = String.fromEnvironment('SII_GATEWAY', defaultValue: 'fake');
  return raw == 'replay' ? DteGatewayMode.replay : DteGatewayMode.fake;
}

DteGateway createDteGateway({
  required SaleRepository sales,
  DteGatewayMode? mode,
  InMemoryCertificateStore? certificateStoreForReplay,
  SiiReplayScenario? replayScenario,
}) {
  final resolved = mode ?? dteGatewayModeFromEnvironment();
  switch (resolved) {
    case DteGatewayMode.replay:
      final certs = certificateStoreForReplay ?? FileCertificateStore.fromEnvironment();
      return SiiCertReplayDteGateway(
        sales: sales,
        certificates: certs,
        scenario: replayScenario ?? SiiReplayScenario.success,
      );
    case DteGatewayMode.fake:
      return FakeDteGateway();
  }
}