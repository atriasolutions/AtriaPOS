import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  test('total suma líneas', () {
    final lines = [
      CartLine(
        lineId: 'l1',
        productId: 'p1',
        productName: 'Pan',
        quantity: 2,
        unitPriceClp: 500,
      ),
    ];
    expect(saleTotalClp(lines), 1000);
  });
}