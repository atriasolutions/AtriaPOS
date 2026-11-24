import 'package:adapters/adapters.dart';
import 'package:core/atria_pos_core.dart';
import 'package:drift/native.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';
  late AppDatabase db;
  late DriftCollaboratorRepository repo;
  late InMemorySessionProvider sessions;
  late CreateCollaborator create;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = DriftCollaboratorRepository(db);
    sessions = InMemorySessionProvider.dueno();
    create = CreateCollaborator(repo, sessions);
  });

  tearDown(() async {
    await db.close();
  });

  test('SC-083-01 persiste colaborador en drift', () async {
    await create(
      const CreateCollaboratorInput(
        storeId: storeId,
        sellerCode: 'V01',
        firstName: 'Colab',
        lastName: 'Drift',
      ),
    );
    final listed = await repo.listByStore(storeId);
    expect(listed, hasLength(1));
    expect(listed.single.sellerCode, 'V01');
    final found = await repo.findActiveBySellerCode(storeId, 'V01');
    expect(found, isNotNull);
  });

  test('desactivar permite nuevo activo mismo código', () async {
    final c = await create(
      const CreateCollaboratorInput(
        storeId: storeId,
        sellerCode: 'V02',
        firstName: 'A',
        lastName: 'B',
      ),
    );
    await DeactivateCollaborator(repo, sessions)(storeId, c.id);
    final c2 = await create(
      const CreateCollaboratorInput(
        storeId: storeId,
        sellerCode: 'V02',
        firstName: 'C',
        lastName: 'D',
      ),
    );
    expect(c2.sellerCode, 'V02');
  });
}