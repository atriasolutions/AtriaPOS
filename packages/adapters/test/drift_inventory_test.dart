import 'package:adapters/adapters.dart';
import 'package:core/pos_barrio_core.dart';
import 'package:drift/native.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';
  late AppDatabase db;
  late DriftProductRepository products;
  late DriftStockMovementRepository movements;
  late CreateProduct createProduct;
  late AdjustStock adjustStock;
  late GetProductStock getProductStock;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    products = DriftProductRepository(db);
    movements = DriftStockMovementRepository(db);
    final sessions = InMemorySessionProvider.supervisor();
    createProduct = CreateProduct(products, sessions);
    adjustStock = AdjustStock(products, movements, sessions);
    getProductStock = GetProductStock(products);
  });

  tearDown(() async {
    await db.close();
  });

  test('ajuste persiste stock y movimiento', () async {
    final created = await createProduct(
      const CreateProductInput(
        storeId: storeId,
        name: 'Pan',
        salePriceClp: 500,
        initialStock: 20,
      ),
    );
  final result = await adjustStock(
      AdjustStockInput(
        storeId: storeId,
        productId: created.id,
        delta: -3,
        reason: StockAdjustmentReason.merma,
      ),
    );
    expect(result.stock, 17);
    final view = await getProductStock(storeId, created.id);
    expect(view.stock, 17);
    final audit = await movements.listByProduct(storeId, created.id);
    expect(audit, hasLength(1));
  });

  test('ajuste transaccional no deja stock sin movimiento si falla', () async {
    final created = await createProduct(
      const CreateProductInput(
        storeId: storeId,
        name: 'Pan',
        salePriceClp: 500,
        initialStock: 2,
      ),
    );
    await expectLater(
      adjustStock(
        AdjustStockInput(
          storeId: storeId,
          productId: created.id,
          delta: -5,
          reason: StockAdjustmentReason.merma,
        ),
      ),
      throwsA(isA<ValidationFailure>()),
    );
    final view = await getProductStock(storeId, created.id);
    expect(view.stock, 2);
    expect(await movements.listByProduct(storeId, created.id), isEmpty);
  });

  test('tabla stock_movements disponible en schema v2', () async {
    final row = await db.customSelect(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='stock_movements'",
    ).getSingle();
    expect(row.read<String>('name'), 'stock_movements');
  });
}