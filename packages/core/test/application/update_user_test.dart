import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

import '../support/auth_fixtures.dart';

void main() {
  const storeId = 't1';

  late InMemoryUserRepository users;
  late BcryptPinHasher hasher;
  late InMemorySessionProvider duenoSession;
  late UpdateUser updateUser;

  setUp(() async {
    users = InMemoryUserRepository();
    hasher = BcryptPinHasher();
    await seedAuthUsers(users, hasher, storeId);
    duenoSession = InMemorySessionProvider(
      initial: AuthSession(
        userId: kTestDuenoId,
        role: UserRole.dueno,
        expiresAt: DateTime.now().toUtc().add(const Duration(hours: 1)),
      ),
    );
    updateUser = UpdateUser(users, hasher, duenoSession);
  });

  test('SC-080-09 edita apellido sin cambiar PIN', () async {
    final updated = await updateUser(
      UpdateUserInput(
        storeId: storeId,
        userId: kTestCajeroId,
        firstName: 'Cajero',
        lastName: 'Actualizado',
        rut: kTestUserRut,
        role: UserRole.cajero,
      ),
    );
    expect(updated.lastName, 'Actualizado');
    expect(updated.displayName, 'Cajero Actualizado');
    final auth = AuthenticateUser(users, hasher, duenoSession);
    await expectLater(
      auth(storeId, 'usr_cajero', kTestPin),
      completes,
    );
  });

  test('SC-080-10 cambia PIN', () async {
    const newPin = '5555';
    await updateUser(
      UpdateUserInput(
        storeId: storeId,
        userId: kTestCajeroId,
        firstName: 'Cajero',
        lastName: 'Demo',
        rut: kTestUserRut,
        role: UserRole.cajero,
        newPin: newPin,
      ),
    );
    final auth = AuthenticateUser(users, hasher, duenoSession);
    await auth(storeId, 'usr_cajero', newPin);
    expect(
      () => auth(storeId, 'usr_cajero', kTestPin),
      throwsA(isA<CredentialFailure>()),
    );
  });

  test('SC-080-11 no asignar rol DUENO', () async {
    expect(
      () => updateUser(
        UpdateUserInput(
          storeId: storeId,
          userId: kTestCajeroId,
          firstName: 'Cajero',
          lastName: 'Demo',
          rut: kTestUserRut,
          role: UserRole.dueno,
        ),
      ),
      throwsA(isA<ValidationFailure>()),
    );
  });

  test('SC-080-12 no cambiar rol del dueño', () async {
    expect(
      () => updateUser(
        UpdateUserInput(
          storeId: storeId,
          userId: kTestDuenoId,
          firstName: 'Dueño',
          lastName: 'Demo',
          rut: kTestUserRut,
          role: UserRole.supervisor,
        ),
      ),
      throwsA(isA<ValidationFailure>()),
    );
  });

  test('SC-080-13 usuario inexistente', () async {
    expect(
      () => updateUser(
        UpdateUserInput(
          storeId: storeId,
          userId: 'missing-id',
          firstName: 'X',
          lastName: 'Y',
          rut: kTestUserRut,
          role: UserRole.cajero,
        ),
      ),
      throwsA(isA<NotFoundFailure>()),
    );
  });
}