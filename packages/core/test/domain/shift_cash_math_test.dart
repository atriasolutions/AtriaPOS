import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  test('ventas total suma', () {
    final sales = [
      Sale(
        id: 's1',
        storeId: 't1',
        shiftId: 'sh1',
        cartId: 'c1',
        lines: const [],
        payments: const [],
        totalClp: 1000,
        changeClp: 0,
        createdAt: DateTime.utc(2026, 1, 1),
      ),
      Sale(
        id: 's2',
        storeId: 't1',
        shiftId: 'sh1',
        cartId: 'c2',
        lines: const [],
        payments: const [],
        totalClp: 500,
        changeClp: 0,
        createdAt: DateTime.utc(2026, 1, 1),
      ),
    ];
    expect(shiftSalesTotalClp(sales), 1500);
  });

  test('efectivo esperado con apertura y venta', () {
    final sales = [
      Sale(
        id: 's1',
        storeId: 't1',
        shiftId: 'sh1',
        cartId: 'c1',
        lines: const [],
        payments: [
          Payment(method: PaymentMethod.efectivo, amountClp: 1000),
        ],
        totalClp: 1000,
        changeClp: 0,
        createdAt: DateTime.utc(2026, 1, 1),
      ),
    ];
    expect(shiftExpectedCashClp(50000, sales), 51000);
  });

  test('SC-145-02 débito y crédito no suman al efectivo esperado', () {
    final sales = [
      Sale(
        id: 's1',
        storeId: 't1',
        shiftId: 'sh1',
        cartId: 'c1',
        lines: const [],
        payments: [
          Payment(method: PaymentMethod.debito, amountClp: 1000),
        ],
        totalClp: 1000,
        changeClp: 0,
        createdAt: DateTime.utc(2026, 1, 1),
      ),
      Sale(
        id: 's2',
        storeId: 't1',
        shiftId: 'sh1',
        cartId: 'c2',
        lines: const [],
        payments: [
          Payment(method: PaymentMethod.credito, amountClp: 2000),
        ],
        totalClp: 2000,
        changeClp: 0,
        createdAt: DateTime.utc(2026, 1, 1),
      ),
    ];
    expect(shiftExpectedCashClp(50000, sales), 50000);
  });

  test('vuelto en efectivo reduce esperado', () {
    final sales = [
      Sale(
        id: 's1',
        storeId: 't1',
        shiftId: 'sh1',
        cartId: 'c1',
        lines: const [],
        payments: [
          Payment(method: PaymentMethod.efectivo, amountClp: 2000),
        ],
        totalClp: 1000,
        changeClp: 1000,
        createdAt: DateTime.utc(2026, 1, 1),
      ),
    ];
    expect(shiftExpectedCashClp(50000, sales), 51000);
  });

  test('SC-032-07 excluye ventas anuladas', () {
    final sales = [
      Sale(
        id: 's1',
        storeId: 't1',
        shiftId: 'sh1',
        cartId: 'c1',
        lines: const [],
        payments: [
          Payment(method: PaymentMethod.efectivo, amountClp: 1000),
        ],
        totalClp: 1000,
        changeClp: 0,
        createdAt: DateTime.utc(2026, 1, 1),
      ),
      Sale(
        id: 's2',
        storeId: 't1',
        shiftId: 'sh1',
        cartId: 'c2',
        lines: const [],
        payments: [
          Payment(method: PaymentMethod.efectivo, amountClp: 2000),
        ],
        totalClp: 2000,
        changeClp: 0,
        createdAt: DateTime.utc(2026, 1, 1),
        status: SaleStatus.anulada,
      ),
    ];
    expect(shiftSalesTotalClp(sales), 1000);
    expect(shiftExpectedCashClp(10000, sales), 11000);
  });
}