import 'package:core/application/application.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';
  late InMemoryProductRepository repository;
  late CreateProduct createProduct;
  late SearchProducts searchProducts;

  setUp(() async {
    repository = InMemoryProductRepository();
    final sessions = InMemorySessionProvider.supervisor();
    createProduct = CreateProduct(repository, sessions);
    searchProducts = SearchProducts(repository);
    await createProduct(
      const CreateProductInput(
        storeId: storeId,
        name: 'Pan hallulla',
        salePriceClp: 500,
        initialStock: 20,
      ),
    );
    await createProduct(
      const CreateProductInput(
        storeId: storeId,
        name: 'Coca-Cola 1.5L',
        salePriceClp: 1500,
        initialStock: 10,
      ),
    );
  });

  test('SC-011-01 búsqueda por texto parcial', () async {
    final results = await searchProducts(storeId, 'hall');
    expect(results, hasLength(1));
    expect(results.first.name, 'Pan hallulla');
  });

  test('SC-011-02 búsqueda por barcode exacto', () async {
    await createProduct(
      const CreateProductInput(
        storeId: storeId,
        name: 'SKU barcode',
        salePriceClp: 100,
        barcode: '7801234567890',
      ),
    );
    final results = await searchProducts(storeId, '7801234567890');
    expect(results, hasLength(1));
    expect(results.first.barcode, '7801234567890');
  });
}