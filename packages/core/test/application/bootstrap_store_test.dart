import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

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
    final result = await bootstrap(
      const BootstrapStoreInput(
        rut: '12.345.678-5',
        legalName: 'Minimarket',
        businessLine: 'Almacén',
        ownerDisplayName: 'Dueño',
        ownerPin: '2468',
      ),
    );
    expect(await stores.count(), 1);
    expect(result.store.legalName, 'Minimarket');
    expect(result.user.role, UserRole.dueno);
    expect(sessions.current?.userId, 'usr_dueno');
  });

  test('SC-001-02 RUT inválido', () async {
    expect(
      () => bootstrap(
        const BootstrapStoreInput(
          rut: '12.345.678-0',
          legalName: 'X',
          businessLine: 'Y',
          ownerDisplayName: 'Dueño',
          ownerPin: '2468',
        ),
      ),
      throwsA(isA<ValidationFailure>()),
    );
    expect(await stores.count(), 0);
  });

  test('SC-001-03 segunda tienda CONFLICTO', () async {
    await bootstrap(
      const BootstrapStoreInput(
        rut: '12.345.678-5',
        legalName: 'A',
        businessLine: 'B',
        ownerDisplayName: 'Dueño',
        ownerPin: '2468',
      ),
    );
    expect(
      () => bootstrap(
        const BootstrapStoreInput(
          rut: '12.345.678-5',
          legalName: 'Otra',
          businessLine: 'C',
          ownerDisplayName: 'Dueño',
          ownerPin: '1357',
        ),
      ),
      throwsA(isA<ConflictFailure>()),
    );
  });
}