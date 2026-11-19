import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';

  test('SC-003-01 certificado vigente', () async {
    final store = InMemoryCertificateStore()
      ..info = CertificateInfo(
        subject: 'CN=Test',
        validFrom: DateTime.now().toUtc().subtract(const Duration(days: 1)),
        validTo: DateTime.now().toUtc().add(const Duration(days: 30)),
        status: CertificateStatus.valido,
      );
    final sessions = InMemorySessionProvider.supervisor();
    final getStatus = GetCertificateStatus(store, sessions);
    final view = await getStatus(storeId);
    expect(view.status, CertificateStatus.valido);
    expect(view.subject, 'CN=Test');
    expect(view.validTo, isNotNull);
  });

  test('SC-003-01 sin certificado → NO_CONFIGURADO', () async {
    final sessions = InMemorySessionProvider.supervisor();
    final getStatus = GetCertificateStatus(InMemoryCertificateStore(), sessions);
    final view = await getStatus(storeId);
    expect(view.status, CertificateStatus.noConfigurado);
    expect(view.subject, isNull);
  });

  test('SC-003-01 vencido por fechas', () async {
    final store = InMemoryCertificateStore()
      ..info = CertificateInfo(
        subject: 'CN=Old',
        validFrom: DateTime.utc(2020, 1, 1),
        validTo: DateTime.utc(2021, 1, 1),
        status: CertificateStatus.vencido,
      );
    final sessions = InMemorySessionProvider.supervisor();
    final getStatus = GetCertificateStatus(store, sessions);
    final view = await getStatus(storeId);
    expect(view.status, CertificateStatus.vencido);
  });
}