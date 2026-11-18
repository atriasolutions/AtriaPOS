import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';

  test('certificado vigente pasa validación', () async {
    final store = InMemoryCertificateStore()
      ..info = CertificateInfo(
        subject: 'CN=Test',
        validFrom: DateTime.now().toUtc().subtract(const Duration(days: 1)),
        validTo: DateTime.now().toUtc().add(const Duration(days: 30)),
        status: CertificateStatus.valido,
      );
    final validate = ValidateCertificate(store);
    final info = await validate(storeId);
    expect(info.isValid, isTrue);
  });

  test('sin certificado → CERT_NO_CONFIGURADO', () async {
    final validate = ValidateCertificate(InMemoryCertificateStore());
    expect(
      () => validate(storeId),
      throwsA(isA<CertificateNotConfiguredFailure>()),
    );
  });

  test('vencido → CERT_VENCIDO', () async {
    final store = InMemoryCertificateStore()
      ..info = CertificateInfo(
        subject: 'CN=Old',
        validFrom: DateTime.utc(2020, 1, 1),
        validTo: DateTime.utc(2021, 1, 1),
        status: CertificateStatus.vencido,
      );
    final validate = ValidateCertificate(store);
    expect(
      () => validate(storeId),
      throwsA(isA<CertificateExpiredFailure>()),
    );
  });
}