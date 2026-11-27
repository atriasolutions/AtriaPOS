import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';

  test('SC-167-01 caducidad obligatoria si flag trackExpiry', () async {
    final stores = InMemoryStoreRepository();
    await stores.save(
      Store.create(
        id: storeId,
        rutRaw: '76123456-0',
        legalName: 'Demo',
        businessLine: 'Retail',
      ).withOperationalOverrides(
        const StoreOperationalOverrides(trackExpiryOnReceipt: true),
      ),
    );
    final products = InMemoryProductRepository();
    final movements = InMemoryStockMovementRepository();
    final sessions = InMemorySessionProvider.supervisor();
    final createProduct = CreateProduct(products, sessions);
    final product = await createProduct(
      const CreateProductInput(
        storeId: storeId,
        name: 'Leche',
        salePriceClp: 1000,
        initialStock: 1,
      ),
    );
    final receipt = RecordStockReceipt(stores, products, movements, sessions);
    await expectLater(
      receipt(
        RecordStockReceiptInput(
          storeId: storeId,
          productId: product.id,
          quantity: 1,
          guideRef: '',
          lotRef: '',
        ),
      ),
      throwsA(isA<ValidationFailure>()),
    );
  });
}