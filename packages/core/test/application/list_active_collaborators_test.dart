import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

import '../support/collaborator_fixtures.dart';

void main() {
  const storeId = 't1';
  late InMemoryCollaboratorRepository repo;
  late ListActiveCollaborators listActive;

  setUp(() async {
    repo = InMemoryCollaboratorRepository();
    listActive = ListActiveCollaborators(
      repo,
      InMemorySessionProvider.cajero(),
    );
    await seedDefaultSeller(repo, storeId, sellerCode: 'V01');
    await repo.save(
      Collaborator.create(
        storeId: storeId,
        sellerCode: 'V02',
        firstName: 'Colab',
        lastName: 'Dos',
      ),
    );
    final off = Collaborator.create(
      storeId: storeId,
      sellerCode: 'V99',
      firstName: 'Colab',
      lastName: 'Inactivo',
    );
    await repo.save(off);
    await repo.save(off.withUpdates(active: false));
  });

  test('SC-084-04 solo devuelve colaboradores activos', () async {
    final items = await listActive(storeId);
    expect(items, hasLength(2));
    expect(items.map((c) => c.sellerCode).toList(), ['V01', 'V02']);
  });

  test('SC-084-05 supervisor puede listar activos', () async {
    final supervisorList = ListActiveCollaborators(
      repo,
      InMemorySessionProvider.supervisor(),
    );
    final items = await supervisorList(storeId);
    expect(items, hasLength(2));
  });

  test('sin sesión → CREDENCIAL', () async {
    final anon = ListActiveCollaborators(
      repo,
      InMemorySessionProvider(),
    );
    expect(
      () => anon(storeId),
      throwsA(isA<CredentialFailure>()),
    );
  });
}