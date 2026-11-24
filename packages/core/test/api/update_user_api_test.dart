import 'package:core/api/api.dart';
import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

import '../support/auth_fixtures.dart';

void main() {
  const storeId = 't1';

  late AuthService service;

  setUp(() async {
    final users = InMemoryUserRepository();
    final hasher = BcryptPinHasher();
    await seedAuthUsers(users, hasher, storeId);
    service = AuthService(
      userRepository: users,
      pinHasher: hasher,
      sessionProvider: InMemorySessionProvider(
        initial: AuthSession(
          userId: kTestDuenoId,
          role: UserRole.dueno,
          expiresAt: DateTime.now().toUtc().add(const Duration(hours: 1)),
        ),
      ),
    );
  });

  test('SC-080-09 API updateUser 200', () async {
    final result = await service.updateUser(
      storeId,
      kTestCajeroId,
      const UpdateUserRequest(
        firstName: 'Cajero',
        lastName: 'Editado',
        rut: kTestUserRut,
        role: 'CAJERO',
      ),
    );
    expect(result, isA<ApiSuccess<UserProfileResponse>>());
    expect(
      (result as ApiSuccess<UserProfileResponse>).data.displayName,
      'Cajero Editado',
    );
  });

  test('usuario inexistente 404', () async {
    final result = await service.updateUser(
      storeId,
      'no-existe',
      const UpdateUserRequest(
        firstName: 'X',
        lastName: 'Y',
        rut: kTestUserRut,
        role: 'CAJERO',
      ),
    );
    expect(result, isA<ApiFailure<UserProfileResponse>>());
    expect((result as ApiFailure).statusCode, 404);
  });
}