import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';

  test('SC-087-01 low stock y SC-087-03 top ventas', () async {
    final products = InMemoryProductRepository();
    final sales = InMemorySaleRepository();
    final sessions = InMemorySessionProvider.supervisor();

    await products.save(
      Product.create(
        id: 'p_low',
        storeId: storeId,
        name: 'Pan',
        salePriceClp: 500,
        initialStock: 2,
      ),
    );
    await products.save(
      Product.create(
        id: 'p_ok',
        storeId: storeId,
        name: 'Agua',
        salePriceClp: 300,
        initialStock: 20,
      ),
    );
    await products.save(
      Product.create(
        id: 'p_top',
        storeId: storeId,
        name: 'Galleta',
        salePriceClp: 200,
        initialStock: 50,
      ),
    );

    await sales.save(
      Sale(
        id: 's1',
        storeId: storeId,
        shiftId: 'sh1',
        cartId: 'c1',
        lines: [
          SaleLine(
            productId: 'p_top',
            productName: 'Galleta',
            quantity: 5,
            unitPriceClp: 200,
          ),
        ],
        payments: const [],
        totalClp: 1000,
        changeClp: 0,
        createdAt: DateTime.utc(2026, 3, 10),
      ),
    );
    await sales.save(
      Sale(
        id: 's2',
        storeId: storeId,
        shiftId: 'sh1',
        cartId: 'c2',
        lines: [
          SaleLine(
            productId: 'p_top',
            productName: 'Galleta',
            quantity: 3,
            unitPriceClp: 200,
          ),
        ],
        payments: const [],
        totalClp: 600,
        changeClp: 0,
        createdAt: DateTime.utc(2026, 3, 15),
      ),
    );

    final insights = GetStockInsights(products, sales, sessions);
    final result = await insights(
      storeId,
      asOfLocal: DateTime(2026, 3, 18),
      topLimit: 10,
    );

    expect(result.lowStock, hasLength(1));
    expect(result.lowStock.single.productId, 'p_low');
    expect(result.lowStock.single.lowStockThreshold, 5);
    expect(result.topSellers.single.productId, 'p_top');
    expect(result.topSellers.single.unitsSold, 8);
  });

  test('SC-087-04 excluye venta anulada del top', () async {
    final products = InMemoryProductRepository();
    final sales = InMemorySaleRepository();
    final sessions = InMemorySessionProvider.supervisor();

    await products.save(
      Product.create(
        id: 'p1',
        storeId: storeId,
        name: 'X',
        salePriceClp: 100,
        initialStock: 10,
      ),
    );
    await sales.save(
      Sale(
        id: 's_void',
        storeId: storeId,
        shiftId: 'sh1',
        cartId: 'c1',
        lines: [
          SaleLine(
            productId: 'p1',
            productName: 'X',
            quantity: 9,
            unitPriceClp: 100,
          ),
        ],
        payments: const [],
        totalClp: 900,
        changeClp: 0,
        createdAt: DateTime.utc(2026, 3, 12),
        status: SaleStatus.anulada,
      ),
    );
    await sales.save(
      Sale(
        id: 's_ok',
        storeId: storeId,
        shiftId: 'sh1',
        cartId: 'c2',
        lines: [
          SaleLine(
            productId: 'p1',
            productName: 'X',
            quantity: 2,
            unitPriceClp: 100,
          ),
        ],
        payments: const [],
        totalClp: 200,
        changeClp: 0,
        createdAt: DateTime.utc(2026, 3, 13),
      ),
    );

    final result = await GetStockInsights(products, sales, sessions)(
      storeId,
      asOfLocal: DateTime(2026, 3, 18),
    );
    expect(result.topSellers.single.unitsSold, 2);
  });

  test('SC-087-05 limit recorta ranking', () async {
    final products = InMemoryProductRepository();
    final sales = InMemorySaleRepository();
    final sessions = InMemorySessionProvider.supervisor();

    for (var i = 1; i <= 3; i++) {
      await products.save(
        Product.create(
          id: 'p$i',
          storeId: storeId,
          name: 'P$i',
          salePriceClp: 100,
          initialStock: 100,
        ),
      );
      await sales.save(
        Sale(
          id: 's$i',
          storeId: storeId,
          shiftId: 'sh1',
          cartId: 'c$i',
          lines: [
            SaleLine(
              productId: 'p$i',
              productName: 'P$i',
              quantity: i * 10,
              unitPriceClp: 100,
            ),
          ],
          payments: const [],
          totalClp: i * 1000,
          changeClp: 0,
          createdAt: DateTime.utc(2026, 3, 10),
        ),
      );
    }

    final result = await GetStockInsights(products, sales, sessions)(
      storeId,
      asOfLocal: DateTime(2026, 3, 18),
      topLimit: 2,
    );
    expect(result.topSellers, hasLength(2));
    expect(result.topSellers.first.unitsSold, 30);
  });

  test('SC-087-06 cajero sin permiso', () async {
    final insights = GetStockInsights(
      InMemoryProductRepository(),
      InMemorySaleRepository(),
      InMemorySessionProvider.cajero(),
    );
    expect(
      () => insights(storeId),
      throwsA(isA<ForbiddenFailure>()),
    );
  });
}