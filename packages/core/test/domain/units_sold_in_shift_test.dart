import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  test('SC-088-04 excluye ventas anuladas', () {
    final units = unitsSoldByProductInShift([
      Sale(
        id: 's1',
        storeId: 't1',
        shiftId: 'sh1',
        cartId: 'c1',
        lines: [
          SaleLine(
            productId: 'p1',
            productName: 'Pan',
            quantity: 5,
            unitPriceClp: 100,
          ),
        ],
        payments: const [],
        totalClp: 500,
        changeClp: 0,
        createdAt: DateTime.utc(2026, 1, 1),
        status: SaleStatus.anulada,
      ),
      Sale(
        id: 's2',
        storeId: 't1',
        shiftId: 'sh1',
        cartId: 'c2',
        lines: [
          SaleLine(
            productId: 'p1',
            productName: 'Pan',
            quantity: 2,
            unitPriceClp: 100,
          ),
        ],
        payments: const [],
        totalClp: 200,
        changeClp: 0,
        createdAt: DateTime.utc(2026, 1, 1),
      ),
    ]);
    expect(units['p1'], 2);
  });
}