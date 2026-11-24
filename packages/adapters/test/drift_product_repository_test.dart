import 'package:adapters/adapters.dart';
import 'package:core/atria_pos_core.dart';
import 'package:drift/native.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';
  late AppDatabase db;
  late DriftProductRepository repository;
  late CreateProduct createProduct;
  late SearchProducts searchProducts;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = DriftProductRepository(db);
    final sessions = InMemorySessionProvider.supervisor();
    createProduct = CreateProduct(repository, sessions);
    searchProducts = SearchProducts(repository);
  });

  tearDown(() async {
    await db.close();
  });

  test('persiste producto y búsqueda por texto', () async {
    await createProduct(
      const CreateProductInput(
        storeId: storeId,
        name: 'Pan hallulla',
        salePriceClp: 500,
        initialStock: 20,
      ),
    );
    final results = await searchProducts(storeId, 'hall');
    expect(results, hasLength(1));
    expect(results.first.stock, 20);
  });

  test('barcode duplicado → CONFLICTO vía caso de uso', () async {
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