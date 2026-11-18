import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';

  group('Product.create', () {
    test('producto válido con stock inicial', () {
      final p = Product.create(
        id: 'p1',
        storeId: storeId,
        name: 'Pan hallulla',
        salePriceClp: 500,
        initialStock: 20,
      );
      expect(p.name, 'Pan hallulla');
      expect(p.stock, 20);
      expect(p.salePriceClp, 500);
    });

    test('precio <= 0 lanza VALIDACION', () {
      expect(
        () => Product.create(
          id: 'p1',
          storeId: storeId,
          name: 'X',
          salePriceClp: 0,
          initialStock: 1,
        ),
        throwsA(isA<ValidationFailure>()),
      );
    });

    test('nombre vacío lanza VALIDACION', () {
      expect(
        () => Product.create(
          id: 'p1',
          storeId: storeId,
          name: '   ',
          salePriceClp: 100,
          initialStock: 0,
        ),
        throwsA(isA<ValidationFailure>()),
      );
    });
  });
}