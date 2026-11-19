import 'package:core/pos_barrio_core.dart';

import 'drift_folio_allocator.dart';
import 'drift_store_repository.dart';
import 'file_certificate_store.dart';
import 'http_sii_transport.dart';
import 'in_memory_folio_allocator.dart';
import 'sii_cert_replay_dte_gateway.dart';
import 'sii_live_dte_gateway.dart';
import 'src/database.dart';

enum DteGatewayMode { fake, replay, live }

/// Certificado activo para emisión y consulta fiscal (DEC-021).
CertificateStore createCertificateStore({
  InMemoryCertificateStore? override,
}) {
  return override ?? FileCertificateStore.fromEnvironment();
}

DteGatewayMode dteGatewayModeFromEnvironment() {
  const raw = String.fromEnvironment('SII_GATEWAY', defaultValue: 'fake');
  return switch (raw) {
    'replay' => DteGatewayMode.replay,
    'live' => DteGatewayMode.live,
    _ => DteGatewayMode.fake,
  };
}

DteGateway createDteGateway({
  required SaleRepository sales,
  DteGatewayMode? mode,
  AppDatabase? database,
  StoreRepository? stores,
  CertificateStore? certificateStoreForReplay,
  SiiReplayScenario? replayScenario,
}) {
  final resolved = mode ?? dteGatewayModeFromEnvironment();
  switch (resolved) {
    case DteGatewayMode.replay:
      final certs = certificateStoreForReplay ?? createCertificateStore();
      return SiiCertReplayDteGateway(
        sales: sales,
        certificates: certs,
        scenario: replayScenario ?? SiiReplayScenario.success,
      );
    case DteGatewayMode.live:
      final certs = certificateStoreForReplay ?? createCertificateStore();
      final folios = database != null
          ? DriftFolioAllocator(database)
          : InMemoryFolioAllocator();
      final storeRepo =
          stores ?? (database != null ? DriftStoreRepository(database) : null);
      return SiiLiveDteGateway(
        sales: sales,
        certificates: certs,
        folios: folios,
        transport: HttpSiiTransport(),
        stores: storeRepo,
      );
    case DteGatewayMode.fake:
      return FakeDteGateway();
  }
}