import 'package:adapters/adapters.dart';
import 'package:core/atria_pos_core.dart';
import 'package:drift/native.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';

  test('SC-088-07 drift persiste cierre y CORRECCION', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final shifts = DriftShiftRepository(db);
    final products = DriftProductRepository(db);
    final movements = DriftStockMovementRepository(db);
    final sales = DriftSaleRepository(db);
    final closes = DriftInventoryCloseRepository(db);
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
        initialStock: 12,
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
    final result = await close(
      storeId,
      [const CloseInventoryLineInput(productId: 'p1', countedQty: 9)],
    );

    final stored = await closes.findById(storeId, result.id);
    expect(stored, isNotNull);
    expect(stored!.lines.single.variance, -3);

    final product = await products.findById(storeId, 'p1');
    expect(product!.stock, 9);

    final movs = await (DriftStockMovementRepository(db))
        .listByProduct(storeId, 'p1');
    expect(movs.single.reason, StockAdjustmentReason.correccion);
  });
}