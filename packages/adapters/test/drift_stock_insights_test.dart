import 'package:adapters/adapters.dart';
import 'package:core/atria_pos_core.dart';
import 'package:drift/native.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';

  test('SC-087-07 drift persiste low_stock_threshold', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final products = DriftProductRepository(db);
    await products.save(
      Product.create(
        id: 'p1',
        storeId: storeId,
        name: 'Pan',
        salePriceClp: 500,
        initialStock: 4,
        lowStockThreshold: 10,
      ),
    );
    final stored = await products.findById(storeId, 'p1');
    expect(stored!.lowStockThreshold, 10);
    expect(LowStockPolicy.isLowStock(stored), isTrue);
  });

  test('SC-087-08 drift topProductsByUnits respeta ventana', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final sales = DriftSaleRepository(db);
    await sales.save(
      Sale(
        id: 's_in',
        storeId: storeId,
        shiftId: 'sh1',
        cartId: 'c1',
        lines: [
          SaleLine(
            productId: 'p1',
            productName: 'Pan',
            quantity: 4,
            unitPriceClp: 100,
          ),
        ],
        payments: const [],
        totalClp: 400,
        changeClp: 0,
        createdAt: DateTime.utc(2026, 3, 17, 12),
      ),
    );
    await sales.save(
      Sale(
        id: 's_out',
        storeId: storeId,
        shiftId: 'sh1',
        cartId: 'c2',
        lines: [
          SaleLine(
            productId: 'p1',
            productName: 'Pan',
            quantity: 99,
            unitPriceClp: 100,
          ),
        ],
        payments: const [],
        totalClp: 9900,
        changeClp: 0,
        createdAt: DateTime.utc(2026, 2, 1),
      ),
    );

    final from = TopSalesPeriodPolicy.fromInclusiveUtc(DateTime(2026, 3, 18));
    final to = TopSalesPeriodPolicy.toExclusiveUtc(DateTime(2026, 3, 18));
    final ranks = await sales.topProductsByUnits(storeId, from, to, 10);
    expect(ranks.single.unitsSold, 4);
  });
}