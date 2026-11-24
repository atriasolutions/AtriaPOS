import 'package:core/api/api.dart';
import 'package:core/application/application.dart';
import 'package:test/test.dart';

import '../support/auth_fixtures.dart';

void main() {
  const storeId = 't1';
  late InMemoryUserRepository users;
  late AuthService auth;

  setUp(() async {
    users = InMemoryUserRepository();
    final hasher = BcryptPinHasher();
    await seedAuthUsers(users, hasher, storeId);
    auth = AuthService(
      userRepository: users,
      pinHasher: hasher,
      sessionProvider: InMemorySessionProvider(),
    );
  });

  test('SC-070-01 login válido', () async {
    final result = await auth.login(
      storeId,
      const LoginRequest(username: 'usr_cajero', pin: kTestPin),
    );
    expect(result, isA<ApiSuccess<LoginResponse>>());
    final body = (result as ApiSuccess<LoginResponse>).data;
    expect(body.role, 'CAJERO');
    expect(auth.sessionProvider.current, isNotNull);
  });

  test('SC-070-02 PIN incorrecto', () async {
    final result = await auth.login(
      storeId,
      const LoginRequest(username: 'usr_cajero', pin: '0000'),
    );
    expect(result, isA<ApiFailure<LoginResponse>>());
    expect((result as ApiFailure<LoginResponse>).error.code, 'CREDENCIAL_INVALIDA');
  });
}