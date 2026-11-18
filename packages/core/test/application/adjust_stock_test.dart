import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';
  late InMemoryProductRepository products;
  late InMemoryStockMovementRepository movements;
  late InMemorySessionProvider sessions;
  late CreateProduct createProduct;
  late AdjustStock adjustStock;
  late GetProductStock getProductStock;

  setUp(() {
    products = InMemoryProductRepository();
    movements = InMemoryStockMovementRepository();
    sessions = InMemorySessionProvider.supervisor();
    createProduct = CreateProduct(products, sessions);
    adjustStock = AdjustStock(products, movements, sessions);
    getProductStock = GetProductStock(products);
  });

  test('SC-021-01 merma decrementa y audita', () async {
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
        note: 'Vencimiento',
      ),
    );
    expect(result.stock, 17);
    final view = await getProductStock(storeId, created.id);
    expect(view.stock, 17);
    final audit = await movements.listByProduct(storeId, created.id);
    expect(audit, hasLength(1));
    expect(audit.first.delta, -3);
    expect(audit.first.reason, StockAdjustmentReason.merma);
  });

  test('SC-021-02 stock negativo → VALIDACION y sin cambio', () async {
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
    final audit = await movements.listByProduct(storeId, created.id);
    expect(audit, isEmpty);
  });

  test('SC-021-03 delta cero → VALIDACION', () async {
    final created = await createProduct(
      const CreateProductInput(
        storeId: storeId,
        name: 'Pan',
        salePriceClp: 500,
        initialStock: 5,
      ),
    );
    await expectLater(
      adjustStock(
        AdjustStockInput(
          storeId: storeId,
          productId: created.id,
          delta: 0,
          reason: StockAdjustmentReason.ajuste,
        ),
      ),
      throwsA(isA<ValidationFailure>()),
    );
  });
}