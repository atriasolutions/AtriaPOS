import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  test('SC-085-02 normaliza mayúsculas', () {
    expect(StockReceiptRefPolicy.normalize('gd-1'), 'GD-1');
  });

  test('SC-085-02 rechaza vacío', () {
    expect(
      () => StockReceiptRefPolicy.validate('   '),
      throwsA(isA<ValidationFailure>()),
    );
  });

  test('rechaza ñ', () {
    expect(
      () => StockReceiptRefPolicy.validate('Gñ-1'),
      throwsA(isA<ValidationFailure>()),
    );
  });
}