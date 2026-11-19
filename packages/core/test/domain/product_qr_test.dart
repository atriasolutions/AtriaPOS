import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  test('SC-010-QR-01 genera payload al crear producto', () {
    final product = Product.create(
      id: 'p1',
      storeId: 't1',
      name: 'Pan',
      salePriceClp: 500,
      initialStock: 1,
    );
    expect(product.qrPayload, contains('sid=t1'));
    expect(product.qrPayload, contains('pid=p1'));
  });

  test('SC-011-QR-01 parsea productId desde QR', () {
    const payload = 'https://pos.barrio/v1/p?sid=t1&pid=p99';
    expect(parseProductIdFromScan(payload), 'p99');
  });
}