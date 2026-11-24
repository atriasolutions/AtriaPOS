import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';

  test('SC-079-01 lista productos con stock', () async {
    final products = InMemoryProductRepository();
    final sessions = InMemorySessionProvider.cajero();
    await products.save(
      Product.create(
        id: 'p1',
        storeId: storeId,
        name: 'Arroz',
        salePriceClp: 1000,
        initialStock: 5,
      ),
    );
    final list = ListStoreProducts(products, sessions);
    final items = await list(storeId);
    expect(items, hasLength(1));
    expect(items.first.stock, 5);
  });

  test('SC-079-02 sin sesión → CREDENCIAL', () async {
    final products = InMemoryProductRepository();
    final sessions = InMemorySessionProvider();
    final list = ListStoreProducts(products, sessions);
    expect(
      () => list(storeId),
      throwsA(isA<CredentialFailure>()),
    );
  });
}