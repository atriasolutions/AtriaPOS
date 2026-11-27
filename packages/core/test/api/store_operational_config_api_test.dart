import 'package:core/api/api.dart';
import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  test('SC-099-01 GET config', () async {
    final stores = InMemoryStoreRepository();
    await stores.save(
      Store.create(
        id: 'store_01',
        rutRaw: '76123456-0',
        legalName: 'Demo',
        businessLine: 'Retail',
      ),
    );
    final service = StoreService(storeRepository: stores);
    final result = await service.getStoreOperationalConfig('store_01');
    expect(result, isA<ApiSuccess<StoreOperationalConfigResponse>>());
    final data = (result as ApiSuccess<StoreOperationalConfigResponse>).data;
    expect(data.schemaVersion, 1);
    expect(data.templateId, 'ATRIA_POS');
    expect(data.effectiveFeatures, contains('inventoryClose'));
  });

  test('SC-099-02 PATCH dueño persiste', () async {
    final stores = InMemoryStoreRepository();
    await stores.save(
      Store.create(
        id: 'store_01',
        rutRaw: '76123456-0',
        legalName: 'Demo',
        businessLine: 'Retail',
      ),
    );
    final sessions = InMemorySessionProvider.dueno(userId: 'u_dueno');
    final service = StoreService(
      storeRepository: stores,
      sessionProvider: sessions,
    );
    final patch = await service.patchStoreOperationalConfig(
      'store_01',
      const PatchStoreOperationalConfigRequest(sellerCodeRequired: true),
    );
    expect(patch, isA<ApiSuccess<StoreOperationalConfigResponse>>());
    final data = (patch as ApiSuccess<StoreOperationalConfigResponse>).data;
    expect(data.effectiveFeatures, contains('sellerCodeCheckout'));
  });

  test('SC-099-02 PATCH supervisor prohibido', () async {
    final stores = InMemoryStoreRepository();
    await stores.save(
      Store.create(
        id: 'store_01',
        rutRaw: '76123456-0',
        legalName: 'Demo',
        businessLine: 'Retail',
      ),
    );
    final sessions = InMemorySessionProvider.supervisor();
    final service = StoreService(
      storeRepository: stores,
      sessionProvider: sessions,
    );
    final patch = await service.patchStoreOperationalConfig(
      'store_01',
      const PatchStoreOperationalConfigRequest(sellerCodeRequired: true),
    );
    expect(patch, isA<ApiFailure<StoreOperationalConfigResponse>>());
    expect((patch as ApiFailure).statusCode, 403);
  });
}