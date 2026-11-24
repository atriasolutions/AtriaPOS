import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  test('SC-087-01 umbral default 5', () {
    final product = Product.create(
      id: 'p1',
      storeId: 't1',
      name: 'Pan',
      salePriceClp: 500,
      initialStock: 2,
    );
    expect(LowStockPolicy.isLowStock(product), isTrue);
    expect(LowStockPolicy.effectiveThreshold(product), 5);
  });

  test('SC-087-02 override por producto', () {
    final product = Product.create(
      id: 'p2',
      storeId: 't1',
      name: 'Arroz',
      salePriceClp: 1000,
      initialStock: 8,
      lowStockThreshold: 10,
    );
    expect(LowStockPolicy.isLowStock(product), isTrue);
    expect(LowStockPolicy.effectiveThreshold(product), 10);
  });
}