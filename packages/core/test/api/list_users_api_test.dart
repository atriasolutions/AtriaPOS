import 'package:core/api/api.dart';
import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

import '../support/auth_fixtures.dart';

void main() {
  const storeId = 't1';

  test('SC-080-07 API listUsers 200', () async {
    final users = InMemoryUserRepository();
    final hasher = BcryptPinHasher();
    await seedAuthUsers(users, hasher, storeId);
    final service = AuthService(
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
    final result = await service.listUsers(storeId);
    expect(result, isA<ApiSuccess<List<UserProfileResponse>>>());
    final list = (result as ApiSuccess<List<UserProfileResponse>>).data;
    expect(list, hasLength(3));
    expect(list.any((u) => u.username == 'usr_cajero'), isTrue);
  });

  test('cajero API 403', () async {
    final service = AuthService(
      sessionProvider: InMemorySessionProvider.cajero(),
    );
    final result = await service.listUsers(storeId);
    expect(result, isA<ApiFailure<List<UserProfileResponse>>>());
    expect((result as ApiFailure).statusCode, 403);
  });
}