import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

const _bootstrapOwner = BootstrapStoreInput(
  rut: '12.345.678-5',
  legalName: 'Minimarket',
  businessLine: 'Almacén',
  ownerFirstName: 'Dueño',
  ownerLastName: 'Tienda',
  ownerUsername: 'jperez',
  ownerRut: '12.345.678-5',
  ownerPin: '2468',
);

void main() {
  late InMemoryStoreRepository stores;
  late InMemoryUserRepository users;
  late InMemorySessionProvider sessions;
  late BootstrapStore bootstrap;

  setUp(() {
    stores = InMemoryStoreRepository();
    users = InMemoryUserRepository();
    sessions = InMemorySessionProvider();
    bootstrap = BootstrapStore(stores, users, BcryptPinHasher(), sessions);
  });

  test('SC-001-01 bootstrap tienda y dueño', () async {
    final result = await bootstrap(_bootstrapOwner);
    expect(await stores.count(), 1);
    expect(result.store.legalName, 'Minimarket');
    expect(result.user.role, UserRole.dueno);
    expect(result.user.username, 'jperez');
    expect(sessions.current?.userId, result.user.id);
  });

  test('SC-001-02 RUT inválido', () async {
    expect(
      () => bootstrap(
        const BootstrapStoreInput(
          rut: '12.345.678-0',
          legalName: 'X',
          businessLine: 'Y',
          ownerFirstName: 'A',
          ownerLastName: 'B',
          ownerUsername: 'dueno1',
          ownerRut: '12.345.678-5',
          ownerPin: '2468',
        ),
      ),
      throwsA(isA<ValidationFailure>()),
    );
    expect(await stores.count(), 0);
  });

  test('SC-001-03 segunda tienda CONFLICTO', () async {
    await bootstrap(_bootstrapOwner);
    expect(
      () => bootstrap(
        const BootstrapStoreInput(
          rut: '12.345.678-5',
          legalName: 'Otra',
          businessLine: 'C',
          ownerFirstName: 'Otro',
          ownerLastName: 'Dueño',
          ownerUsername: 'otro',
          ownerRut: '12.345.678-5',
          ownerPin: '1357',
        ),
      ),
      throwsA(isA<ConflictFailure>()),
    );
  });
}