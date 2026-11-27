import 'package:core/api/api.dart';
import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  test('SC-089-02 API pos-template 200', () async {
    final stores = InMemoryStoreRepository();
    await stores.save(
      Store.create(
        id: 'store_01',
        rutRaw: '12.345.678-5',
        legalName: 'Minimarket',
        businessLine: 'Almacén',
      ),
    );
    final service = StoreService(storeRepository: stores);
    final result = await service.getPosTemplate('store_01');
    expect(result, isA<ApiSuccess<PosTemplateResponse>>());
    final data = (result as ApiSuccess<PosTemplateResponse>).data;
    expect(data.templateId, 'ATRIA_POS');
    expect(data.displayName, 'Atria POS');
    expect(data.features, isNot(contains('sellerCodeCheckout')));
    expect(data.features, contains('collaboratorPlanilla'));
    expect(data.features, isNotEmpty);
  });

  test('storeId inexistente → 404', () async {
    final service = StoreService();
    final result = await service.getPosTemplate('missing');
    expect(result, isA<ApiFailure<PosTemplateResponse>>());
    expect((result as ApiFailure).statusCode, 404);
  });
}