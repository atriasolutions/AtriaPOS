import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';

  test('SC-088-01 preview con ventas del turno', () async {
    final shifts = InMemoryShiftRepository();
    final products = InMemoryProductRepository();
    final sales = InMemorySaleRepository();
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
    await sales.save(
      Sale(
        id: 's1',
        storeId: storeId,
        shiftId: 'sh1',
        cartId: 'c1',
        lines: [
          SaleLine(
            productId: 'p1',
            productName: 'Pan',
            quantity: 3,
            unitPriceClp: 500,
          ),
        ],
        payments: const [],
        totalClp: 1500,
        changeClp: 0,
        createdAt: DateTime.utc(2026, 1, 1),
      ),
    );

    final preview = await GetInventoryClosePreview(
      shifts,
      products,
      sales,
      sessions,
    )(storeId);

    expect(preview.shiftId, 'sh1');
    expect(preview.items.single.unitsSoldInShift, 3);
    expect(preview.items.single.systemStock, 10);
  });

  test('SC-088-05 sin turno abierto', () async {
    expect(
      () => GetInventoryClosePreview(
        InMemoryShiftRepository(),
        InMemoryProductRepository(),
        InMemorySaleRepository(),
        InMemorySessionProvider.supervisor(),
      )(storeId),
      throwsA(isA<NotFoundFailure>()),
    );
  });
}