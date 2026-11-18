import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  group('StockAdjustmentReason.fromApi', () {
    test('acepta MERMA', () {
      expect(
        StockAdjustmentReason.fromApi('merma'),
        StockAdjustmentReason.merma,
      );
    });

    test('motivo inválido lanza VALIDACION', () {
      expect(
        () => StockAdjustmentReason.fromApi('OTRO'),
        throwsA(isA<ValidationFailure>()),
      );
    });
  });

  group('StockMovement.record', () {
    test('delta cero lanza VALIDACION', () {
      expect(
        () => StockMovement.record(
          storeId: 't1',
          productId: 'p1',
          delta: 0,
          reason: StockAdjustmentReason.merma,
        ),
        throwsA(isA<ValidationFailure>()),
      );
    });
  });

  group('Product.applyStockDelta', () {
    test('rechaza stock negativo', () {
      final product = Product(
        id: 'p1',
        storeId: 't1',
        name: 'X',
        salePriceClp: 100,
        stock: 2,
      );
      expect(
        () => product.applyStockDelta(-5),
        throwsA(isA<ValidationFailure>()),
      );
    });
  });
}