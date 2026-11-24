import 'package:core/api/api.dart';
import 'package:core/application/application.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';
  late CollaboratorService service;

  setUp(() {
    service = CollaboratorService(
      sessionProvider: InMemorySessionProvider.dueno(),
    );
  });

  test('SC-083-02 duplicado → 409', () async {
    await service.create(
      storeId,
      const CreateCollaboratorRequest(
        sellerCode: 'V01',
        firstName: 'Colab',
        lastName: 'Uno',
      ),
    );
    final dup = await service.create(
      storeId,
      const CreateCollaboratorRequest(
        sellerCode: 'V01',
        firstName: 'Otro',
        lastName: 'Dos',
      ),
    );
    expect(dup, isA<ApiFailure<CollaboratorResponse>>());
    expect((dup as ApiFailure<CollaboratorResponse>).statusCode, 409);
  });

  test('SC-083-04 actualizar apellido', () async {
    final created = await service.create(
      storeId,
      const CreateCollaboratorRequest(
        sellerCode: 'V03',
        firstName: 'Colab',
        lastName: 'Viejo',
      ),
    );
    final id = (created as ApiSuccess<CollaboratorResponse>).data.id;
    final updated = await service.update(
      storeId,
      id,
      const UpdateCollaboratorRequest(lastName: 'Nuevo'),
    );
    expect((updated as ApiSuccess<CollaboratorResponse>).data.lastName, 'Nuevo');
  });

  test('SC-083-05 desactivar libera código', () async {
    final created = await service.create(
      storeId,
      const CreateCollaboratorRequest(
        sellerCode: 'V04',
        firstName: 'Colab',
        lastName: 'Cuatro',
      ),
    );
    final id = (created as ApiSuccess<CollaboratorResponse>).data.id;
    await service.deactivate(storeId, id);
    final again = await service.create(
      storeId,
      const CreateCollaboratorRequest(
        sellerCode: 'V04',
        firstName: 'Otro',
        lastName: 'Otro',
      ),
    );
    expect(again, isA<ApiSuccess<CollaboratorResponse>>());
  });

  test('SC-083-06 código inválido → 400', () async {
    final result = await service.create(
      storeId,
      const CreateCollaboratorRequest(
        sellerCode: 'X',
        firstName: 'Colab',
        lastName: 'Corto',
      ),
    );
    expect(result, isA<ApiFailure<CollaboratorResponse>>());
    expect((result as ApiFailure<CollaboratorResponse>).error.code, 'VALIDACION');
  });
}