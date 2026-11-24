import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';
  late InMemoryProductRepository products;
  late InMemoryStockMovementRepository movements;
  late InMemorySessionProvider sessions;
  late CreateProduct createProduct;
  late RecordStockReceipt recordReceipt;
  late GetProductStock getProductStock;

  setUp(() {
    products = InMemoryProductRepository();
    movements = InMemoryStockMovementRepository();
    sessions = InMemorySessionProvider.supervisor();
    createProduct = CreateProduct(products, sessions);
    recordReceipt = RecordStockReceipt(products, movements, sessions);
    getProductStock = GetProductStock(products);
  });

  test('SC-085-01 ingreso válido persiste refs', () async {
    final created = await createProduct(
      const CreateProductInput(
        storeId: storeId,
        name: 'Pan',
        salePriceClp: 500,
        initialStock: 5,
      ),
    );
    final result = await recordReceipt(
      RecordStockReceiptInput(
        storeId: storeId,
        productId: created.id,
        quantity: 10,
        guideRef: 'gd-123',
        lotRef: 'l-01',
      ),
    );
    expect(result.stock, 15);
    expect(result.guideRef, 'GD-123');
    expect(result.lotRef, 'L-01');
    final stock = await getProductStock(storeId, created.id);
    expect(stock.stock, 15);
    final audit = await movements.listByProduct(storeId, created.id);
    expect(audit.single.reason, StockAdjustmentReason.recepcion);
    expect(audit.single.guideRef, 'GD-123');
    expect(audit.single.lotRef, 'L-01');
    expect(audit.single.delta, 10);
  });

  test('SC-085-02 quantity cero → VALIDACION', () async {
    final created = await createProduct(
      const CreateProductInput(
        storeId: storeId,
        name: 'Pan',
        salePriceClp: 500,
        initialStock: 5,
      ),
    );
    await expectLater(
      recordReceipt(
        RecordStockReceiptInput(
          storeId: storeId,
          productId: created.id,
          quantity: 0,
          guideRef: 'G1',
          lotRef: 'L1',
        ),
      ),
      throwsA(isA<ValidationFailure>()),
    );
  });

  test('SC-085-03 producto inexistente → NO_ENCONTRADO', () async {
    await expectLater(
      recordReceipt(
        const RecordStockReceiptInput(
          storeId: storeId,
          productId: 'missing',
          quantity: 1,
          guideRef: 'G1',
          lotRef: 'L1',
        ),
      ),
      throwsA(isA<NotFoundFailure>()),
    );
  });

  test('SC-085-04 cajero → PERMISO_DENEGADO', () async {
    final cajero = RecordStockReceipt(
      products,
      movements,
      InMemorySessionProvider.cajero(),
    );
    final created = await createProduct(
      const CreateProductInput(
        storeId: storeId,
        name: 'Pan',
        salePriceClp: 500,
        initialStock: 5,
      ),
    );
    await expectLater(
      cajero(
        RecordStockReceiptInput(
          storeId: storeId,
          productId: created.id,
          quantity: 1,
          guideRef: 'G1',
          lotRef: 'L1',
        ),
      ),
      throwsA(isA<ForbiddenFailure>()),
    );
  });
}