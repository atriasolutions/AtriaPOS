import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  test('SC-083-06 normaliza mayúsculas', () {
    expect(SellerCodePolicy.normalize('v01'), 'V01');
  });

  test('SC-083-06 rechaza ñ', () {
    expect(
      () => SellerCodePolicy.validate('VÑ1'),
      throwsA(isA<ValidationFailure>()),
    );
  });

  test('rechaza código corto', () {
    expect(
      () => SellerCodePolicy.validate('V'),
      throwsA(isA<ValidationFailure>()),
    );
  });
}