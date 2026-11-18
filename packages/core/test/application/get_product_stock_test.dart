import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';
  late InMemoryProductRepository products;
  late CreateProduct createProduct;
  late GetProductStock getProductStock;

  setUp(() {
    products = InMemoryProductRepository();
    final sessions = InMemorySessionProvider.supervisor();
    createProduct = CreateProduct(products, sessions);
    getProductStock = GetProductStock(products);
  });

  test('SC-020-01 consulta stock correcto', () async {
    final created = await createProduct(
      const CreateProductInput(
        storeId: storeId,
        name: 'Pan',
        salePriceClp: 500,
        initialStock: 20,
      ),
    );
    final view = await getProductStock(storeId, created.id);
    expect(view.stock, 20);
    expect(view.productId, created.id);
  });

  test('SC-020-02 producto inexistente → NO_ENCONTRADO', () async {
    expect(
      () => getProductStock(storeId, 'missing'),
      throwsA(isA<NotFoundFailure>()),
    );
  });
}