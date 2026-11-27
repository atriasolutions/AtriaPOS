import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';

  Future<CloseInventory> buildClose({
    SessionProvider? sessions,
  }) async {
    final shifts = InMemoryShiftRepository();
    final products = InMemoryProductRepository();
    final sales = InMemorySaleRepository();
    final movements = InMemoryStockMovementRepository();
    final closes = InMemoryInventoryCloseRepository();
    final sessions0 = sessions ?? InMemorySessionProvider.supervisor();

    await shifts.save(
      Shift(
        id: 'sh1',
        storeId: storeId,
        openingCashClp: 0,
        openedAt: DateTime.utc(2026, 1, 1),
        status: ShiftStatus.abierto,
      ),
    );
    await products.save(
      Product.create(
        id: 'p1',
        storeId: storeId,
        name: 'Pan',
        salePriceClp: 500,
        initialStock: 10,
      ),
    );

    final adjust = AdjustStock(products, movements, sessions0);
    return CloseInventory(
      shifts,
      products,
      sales,
      adjust,
      closes,
      sessions0,
    );
  }

  test('SC-088-02 stock actualizado y movimiento', () async {
    final shifts = InMemoryShiftRepository();
    final products = InMemoryProductRepository();
    final sales = InMemorySaleRepository();
    final movements = InMemoryStockMovementRepository();
    final closes = InMemoryInventoryCloseRepository();
    final sessions = InMemorySessionProvider.supervisor();
    await shifts.save(
      Shift(
        id: 'sh1',
        storeId: storeId,
        openingCashClp: 0,
        openedAt: DateTime.utc(2026, 1, 1),
        status: ShiftStatus.abierto,
      ),
    );
    await products.save(
      Product.create(
        id: 'p1',
        storeId: storeId,
        name: 'Pan',
        salePriceClp: 500,
        initialStock: 10,
      ),
    );
    final adjust = AdjustStock(products, movements, sessions);
    final close = CloseInventory(
      shifts,
      products,
      sales,
      adjust,
      closes,
      sessions,
    );

    await close(
      storeId,
      [const CloseInventoryLineInput(productId: 'p1', countedQty: 7)],
    );

    final stored = await products.findById(storeId, 'p1');
    expect(stored!.stock, 7);
    final movs = await movements.listByProduct(storeId, 'p1');
    expect(movs.single.reason, StockAdjustmentReason.correccion);
    expect(movs.single.delta, -3);
  });

  test('SC-088-03 variance cero sin movimiento', () async {
    final shifts = InMemoryShiftRepository();
    final products = InMemoryProductRepository();
    final sales = InMemorySaleRepository();
    final movements = InMemoryStockMovementRepository();
    final closes = InMemoryInventoryCloseRepository();
    final sessions = InMemorySessionProvider.supervisor();
    await shifts.save(
      Shift(
        id: 'sh1',
        storeId: storeId,
        openingCashClp: 0,
        openedAt: DateTime.utc(2026, 1, 1),
        status: ShiftStatus.abierto,
      ),
    );
    await products.save(
      Product.create(
        id: 'p1',
        storeId: storeId,
        name: 'Pan',
        salePriceClp: 500,
        initialStock: 10,
      ),
    );
    final adjust = AdjustStock(products, movements, sessions);
    final close = CloseInventory(
      shifts,
      products,
      sales,
      adjust,
      closes,
      sessions,
    );

    final saved = await close(
      storeId,
      [const CloseInventoryLineInput(productId: 'p1', countedQty: 10)],
    );
    expect(saved.lines.single.variance, 0);
    expect(await movements.listByProduct(storeId, 'p1'), isEmpty);
  });

  test('SC-088-06 cajero sin permiso', () async {
    final close = await buildClose(sessions: InMemorySessionProvider.cajero());
    expect(
      () => close(
        storeId,
        [const CloseInventoryLineInput(productId: 'p1', countedQty: 5)],
      ),
      throwsA(isA<ForbiddenFailure>()),
    );
  });

  test('SC-153-01 falta SKU del catálogo', () async {
    final shifts = InMemoryShiftRepository();
    final products = InMemoryProductRepository();
    final sales = InMemorySaleRepository();
    final movements = InMemoryStockMovementRepository();
    final closes = InMemoryInventoryCloseRepository();
    final sessions = InMemorySessionProvider.supervisor();
    await shifts.save(
      Shift(
        id: 'sh1',
        storeId: storeId,
        openingCashClp: 0,
        openedAt: DateTime.utc(2026, 1, 1),
        status: ShiftStatus.abierto,
      ),
    );
    await products.save(
      Product.create(
        id: 'p1',
        storeId: storeId,
        name: 'Pan',
        salePriceClp: 500,
        initialStock: 10,
      ),
    );
    await products.save(
      Product.create(
        id: 'p2',
        storeId: storeId,
        name: 'Leche',
        salePriceClp: 900,
        initialStock: 5,
      ),
    );
    final close = CloseInventory(
      shifts,
      products,
      sales,
      AdjustStock(products, movements, sessions),
      closes,
      sessions,
    );
    expect(
      () => close(
        storeId,
        [const CloseInventoryLineInput(productId: 'p1', countedQty: 10)],
      ),
      throwsA(
        isA<ValidationFailure>().having(
          (e) => e.message,
          'message',
          'Complete el conteo de todos los productos',
        ),
      ),
    );
  });

  test('SC-153-02 catálogo completo cierra', () async {
    final shifts = InMemoryShiftRepository();
    final products = InMemoryProductRepository();
    final sales = InMemorySaleRepository();
    final movements = InMemoryStockMovementRepository();
    final closes = InMemoryInventoryCloseRepository();
    final sessions = InMemorySessionProvider.supervisor();
    await shifts.save(
      Shift(
        id: 'sh1',
        storeId: storeId,
        openingCashClp: 0,
        openedAt: DateTime.utc(2026, 1, 1),
        status: ShiftStatus.abierto,
      ),
    );
    await products.save(
      Product.create(
        id: 'p1',
        storeId: storeId,
        name: 'Pan',
        salePriceClp: 500,
        initialStock: 10,
      ),
    );
    await products.save(
      Product.create(
        id: 'p2',
        storeId: storeId,
        name: 'Leche',
        salePriceClp: 900,
        initialStock: 5,
      ),
    );
    final close = CloseInventory(
      shifts,
      products,
      sales,
      AdjustStock(products, movements, sessions),
      closes,
      sessions,
    );
    final saved = await close(
      storeId,
      const [
        CloseInventoryLineInput(productId: 'p1', countedQty: 10),
        CloseInventoryLineInput(productId: 'p2', countedQty: 5),
      ],
    );
    expect(saved.lines.length, 2);
  });

  test('SC-088-08 producto duplicado', () async {
    final close = await buildClose();
    expect(
      () => close(
        storeId,
        const [
          CloseInventoryLineInput(productId: 'p1', countedQty: 5),
          CloseInventoryLineInput(productId: 'p1', countedQty: 6),
        ],
      ),
      throwsA(isA<ValidationFailure>()),
    );
  });
}