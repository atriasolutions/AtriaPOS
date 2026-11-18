import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';

  test('lista ventas del turno abierto ordenadas', () async {
    final sales = InMemorySaleRepository();
    final shifts = InMemoryShiftRepository();
    await shifts.save(
      Shift(
        id: 'sh1',
        storeId: storeId,
        openingCashClp: 0,
        openedAt: DateTime.utc(2026, 1, 1),
        status: ShiftStatus.abierto,
      ),
    );
    await sales.save(
      Sale(
        id: 'sale_old',
        storeId: storeId,
        shiftId: 'sh1',
        cartId: 'c1',
        lines: const [],
        payments: [
          Payment.create(method: PaymentMethod.efectivo, amountClp: 100),
        ],
        totalClp: 100,
        changeClp: 0,
        createdAt: DateTime.utc(2026, 1, 1, 10),
      ),
    );
    await sales.save(
      Sale(
        id: 'sale_new',
        storeId: storeId,
        shiftId: 'sh1',
        cartId: 'c2',
        lines: const [],
        payments: [
          Payment.create(method: PaymentMethod.efectivo, amountClp: 200),
        ],
        totalClp: 200,
        changeClp: 0,
        createdAt: DateTime.utc(2026, 1, 1, 12),
      ),
    );
    final list = ListShiftSales(
      sales,
      shifts,
      InMemorySessionProvider.supervisor(),
    );
    final result = await list(storeId);
    expect(result.length, 2);
    expect(result.first.saleId, 'sale_new');
  });

  test('sin turno abierto', () async {
    final list = ListShiftSales(
      InMemorySaleRepository(),
      InMemoryShiftRepository(),
      InMemorySessionProvider.supervisor(),
    );
    expect(
      () => list(storeId),
      throwsA(isA<TurnClosedFailure>()),
    );
  });
}