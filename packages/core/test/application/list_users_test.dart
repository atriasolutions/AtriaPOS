import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

import '../support/auth_fixtures.dart';

void main() {
  const storeId = 't1';

  test('SC-080-07 dueño lista usuarios por tienda', () async {
    final users = InMemoryUserRepository();
    final hasher = BcryptPinHasher();
    await seedAuthUsers(users, hasher, storeId);
    final sessions = InMemorySessionProvider(
      initial: AuthSession(
        userId: kTestDuenoId,
        role: UserRole.dueno,
        expiresAt: DateTime.now().toUtc().add(const Duration(hours: 1)),
      ),
    );
    final listUsers = ListUsers(users, sessions);
    final listed = await listUsers(storeId);
    expect(listed, hasLength(3));
    expect(listed.map((u) => u.username), contains('usr_cajero'));
    final usernames = listed.map((u) => u.username).toList();
    expect(usernames, ['usr_cajero', 'usr_dueno', 'usr_supervisor']);
  });

  test('SC-080-08 cajero sin permiso', () async {
    final users = InMemoryUserRepository();
    final sessions = InMemorySessionProvider.cajero();
    final listUsers = ListUsers(users, sessions);
    expect(() => listUsers(storeId), throwsA(isA<ForbiddenFailure>()));
  });
}