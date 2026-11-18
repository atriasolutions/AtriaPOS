import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';
  late InMemoryProductRepository repository;
  late CreateProduct createProduct;

  setUp(() {
    repository = InMemoryProductRepository();
    final sessions = InMemorySessionProvider.supervisor();
    createProduct = CreateProduct(repository, sessions);
  });

  test('SC-010-01 crea producto válido con stock inicial', () async {
    final product = await createProduct(
      const CreateProductInput(
        storeId: storeId,
        name: 'Pan hallulla',
        salePriceClp: 500,
        initialStock: 20,
      ),
    );
    expect(product.stock, 20);
    expect(product.name, 'Pan hallulla');
    final loaded = await repository.findById(storeId, product.id);
    expect(loaded, isNotNull);
  });

  test('SC-010-02 precio inválido → VALIDACION', () async {
    expect(
      () => createProduct(
        const CreateProductInput(
          storeId: storeId,
          name: 'X',
          salePriceClp: 0,
        ),
      ),
      throwsA(isA<ValidationFailure>()),
    );
  });

  test('SC-010-03 barcode duplicado → CONFLICTO', () async {
    await createProduct(
      const CreateProductInput(
        storeId: storeId,
        name: 'A',
        salePriceClp: 100,
        barcode: '7801234567890',
      ),
    );
    expect(
      () => createProduct(
        const CreateProductInput(
          storeId: storeId,
          name: 'B',
          salePriceClp: 200,
          barcode: '7801234567890',
        ),
      ),
      throwsA(isA<ConflictFailure>()),
    );
  });
}