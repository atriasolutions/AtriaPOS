import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';
  late InMemoryCollaboratorRepository repo;
  late InMemorySessionProvider sessions;
  late CreateCollaborator create;

  setUp(() {
    repo = InMemoryCollaboratorRepository();
    sessions = InMemorySessionProvider.dueno();
    create = CreateCollaborator(repo, sessions);
  });

  test('SC-083-01 dueño crea colaborador', () async {
    final c = await create(
      const CreateCollaboratorInput(
        storeId: storeId,
        sellerCode: 'v01',
        firstName: 'Colab',
        lastName: 'Uno',
      ),
    );
    expect(c.sellerCode, 'V01');
    expect(c.active, isTrue);
    final listed = await ListCollaborators(repo, sessions)(storeId);
    expect(listed, hasLength(1));
  });

  test('SC-083-02 código duplicado activo', () async {
    await create(
      const CreateCollaboratorInput(
        storeId: storeId,
        sellerCode: 'V01',
        firstName: 'Colab',
        lastName: 'Uno',
      ),
    );
    expect(
      () => create(
        const CreateCollaboratorInput(
          storeId: storeId,
          sellerCode: 'V01',
          firstName: 'Colab',
          lastName: 'Dos',
        ),
      ),
      throwsA(isA<ConflictFailure>()),
    );
  });

  test('SC-083-03 supervisor sin permiso', () async {
    final denied = CreateCollaborator(
      repo,
      InMemorySessionProvider.supervisor(),
    );
    expect(
      () => denied(
        const CreateCollaboratorInput(
          storeId: storeId,
          sellerCode: 'V02',
          firstName: 'Colab',
          lastName: 'Dos',
        ),
      ),
      throwsA(isA<ForbiddenFailure>()),
    );
  });
}