import 'package:core/api/api.dart';
import 'package:core/application/application.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';

  test('SC-083-03 supervisor → 403 al crear', () async {
    final service = CollaboratorService(
      sessionProvider: InMemorySessionProvider.supervisor(),
    );
    final result = await service.create(
      storeId,
      const CreateCollaboratorRequest(
        sellerCode: 'V01',
        firstName: 'Colab',
        lastName: 'Uno',
      ),
    );
    expect(result, isA<ApiFailure<CollaboratorResponse>>());
    expect((result as ApiFailure<CollaboratorResponse>).statusCode, 403);
  });

  test('SC-083-01 dueño crea → 201', () async {
    final service = CollaboratorService(
      sessionProvider: InMemorySessionProvider.dueno(),
    );
    final result = await service.create(
      storeId,
      const CreateCollaboratorRequest(
        sellerCode: 'V01',
        firstName: 'Colab',
        lastName: 'Uno',
      ),
    );
    expect(result, isA<ApiSuccess<CollaboratorResponse>>());
    expect((result as ApiSuccess<CollaboratorResponse>).data.sellerCode, 'V01');
  });
}