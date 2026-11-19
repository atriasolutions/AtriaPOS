import 'package:core/api/api.dart';
import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';

  test('SC-003-01 API certificado vigente', () async {
    final store = InMemoryCertificateStore()
      ..info = CertificateInfo(
        subject: 'CN=Emit',
        validFrom: DateTime.now().toUtc().subtract(const Duration(days: 1)),
        validTo: DateTime.now().toUtc().add(const Duration(days: 90)),
        status: CertificateStatus.valido,
      );
    final service = FiscalService(
      certificateStore: store,
      sessionProvider: InMemorySessionProvider.supervisor(),
    );
    final result = await service.getCertificate(storeId);
    expect(result, isA<ApiSuccess<CertificateStatusResponse>>());
    final data = (result as ApiSuccess<CertificateStatusResponse>).data;
    expect(data.status, 'VALIDO');
    expect(data.subject, 'CN=Emit');
    expect(data.validTo, isNotNull);
  });

  test('cajero → 403', () async {
    final service = FiscalService(
      sessionProvider: InMemorySessionProvider.cajero(),
    );
    final result = await service.getCertificate(storeId);
    expect(result, isA<ApiFailure<CertificateStatusResponse>>());
    expect((result as ApiFailure).statusCode, 403);
  });
}