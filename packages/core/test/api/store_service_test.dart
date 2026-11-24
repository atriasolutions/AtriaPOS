import 'package:core/api/api.dart';
import 'package:core/application/application.dart';
import 'package:test/test.dart';

void main() {
  late StoreService service;

  setUp(() {
    service = StoreService();
  });

  test('SC-001-01 API bootstrap 201', () async {
    final result = await service.bootstrap(
      const BootstrapStoreRequest(
        rut: '12.345.678-5',
        legalName: 'Minimarket',
        businessLine: 'Almacén',
        ownerFirstName: 'Dueño',
        ownerLastName: 'Tienda',
        ownerUsername: 'jperez',
        ownerRut: '12.345.678-5',
        ownerPin: '2468',
      ),
    );
    expect(result, isA<ApiSuccess<BootstrapStoreResponse>>());
    expect((result as ApiSuccess).statusCode, 201);
  });

  test('SC-001-02 API bootstrap RUT inválido 400', () async {
    final result = await service.bootstrap(
      const BootstrapStoreRequest(
        rut: '12.345.678-0',
        legalName: 'X',
        businessLine: 'Y',
        ownerFirstName: 'A',
        ownerLastName: 'B',
        ownerUsername: 'ab',
        ownerRut: '12.345.678-5',
        ownerPin: '2468',
      ),
    );
    expect(result, isA<ApiFailure<BootstrapStoreResponse>>());
    expect((result as ApiFailure).statusCode, 400);
  });

  test('getActiveStore 404 sin tienda', () async {
    final result = await service.getActiveStore();
    expect(result, isA<ApiFailure<ActiveStoreResponse>>());
    expect((result as ApiFailure).statusCode, 404);
  });
}