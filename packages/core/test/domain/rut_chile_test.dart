import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  test('RutChile valida 12.345.678-5', () {
    expect(RutChile.isValid('12.345.678-5'), isTrue);
    expect(RutChile.isValid('12345678-5'), isTrue);
  });

  test('RutChile rechaza DV incorrecto', () {
    expect(RutChile.isValid('12.345.678-0'), isFalse);
  });

  test('formatDisplay agrega puntos', () {
    expect(RutChile.formatDisplay('12345678-5'), '12.345.678-5');
  });
}