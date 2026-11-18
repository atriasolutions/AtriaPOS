import 'package:core/api/api.dart';
import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

import '../support/auth_fixtures.dart';

void main() {
  const storeId = 't1';

  test('SC-070-04 solo dueño crea usuarios', () async {
    final users = InMemoryUserRepository();
    final hasher = BcryptPinHasher();
    await seedAuthUsers(users, hasher, storeId);

    final cajeroSession = InMemorySessionProvider(
      initial: AuthSession(
        userId: 'usr_cajero',
        role: UserRole.cajero,
        expiresAt: DateTime.now().toUtc().add(const Duration(hours: 1)),
      ),
    );
    final denied = AuthService(
      userRepository: users,
      pinHasher: hasher,
      sessionProvider: cajeroSession,
    );
    final fail = await denied.createUser(
      storeId,
      const CreateUserRequest(
        userId: 'usr_nuevo',
        displayName: 'Nuevo',
        role: 'CAJERO',
        pin: '9999',
      ),
    );
    expect(fail, isA<ApiFailure<CreateUserResponse>>());
    expect((fail as ApiFailure<CreateUserResponse>).statusCode, 403);

    final duenoSession = InMemorySessionProvider(
      initial: AuthSession(
        userId: 'usr_dueno',
        role: UserRole.dueno,
        expiresAt: DateTime.now().toUtc().add(const Duration(hours: 1)),
      ),
    );
    final ok = AuthService(
      userRepository: users,
      pinHasher: hasher,
      sessionProvider: duenoSession,
    );
    final created = await ok.createUser(
      storeId,
      const CreateUserRequest(
        userId: 'usr_nuevo',
        displayName: 'Nuevo',
        role: 'CAJERO',
        pin: '9999',
      ),
    );
    expect(created, isA<ApiSuccess<CreateUserResponse>>());
  });
}