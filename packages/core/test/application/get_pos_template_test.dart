import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  late InMemoryStoreRepository stores;
  late GetPosTemplate getPosTemplate;

  setUp(() {
    stores = InMemoryStoreRepository();
    getPosTemplate = GetPosTemplate(stores);
  });

  test('SC-089-01 consulta plantilla de tienda', () async {
    const storeId = 'store_01';
    await stores.save(
      Store.create(
        id: storeId,
        rutRaw: '12.345.678-5',
        legalName: 'Minimarket',
        businessLine: 'Almacén',
      ),
    );
    final template = await getPosTemplate(storeId);
    expect(template.id, PosTemplateId.atriaPos);
    expect(template.features, contains(PosFeature.auditTrail));
  });

  test('tienda inexistente → NotFoundFailure', () async {
    expect(
      () => getPosTemplate('missing'),
      throwsA(isA<NotFoundFailure>()),
    );
  });
}