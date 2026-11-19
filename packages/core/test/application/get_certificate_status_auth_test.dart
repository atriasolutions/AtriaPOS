import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';

  test('SC-003-01 cajero no consulta certificado', () async {
    final sessions = InMemorySessionProvider.cajero();
    final getStatus = GetCertificateStatus(
      InMemoryCertificateStore(),
      sessions,
    );
    expect(
      () => getStatus(storeId),
      throwsA(isA<ForbiddenFailure>()),
    );
  });
}