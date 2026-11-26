import 'package:companion_web/companion_armed_scan.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final t0 = DateTime.utc(2026, 11, 26, 12);

  test('SC-137-01 dos detecciones iguales no envían hasta confirmar', () {
    final armed = CompanionArmedScan();
    expect(armed.onDetect('7801', t0), isTrue);
    expect(armed.onDetect('7801', t0), isFalse);
    expect(armed.pending, '7801');
  });

  test('SC-137-02 trigger entrega una vez y limpia el buffer', () {
    final armed = CompanionArmedScan();
    armed.onDetect('7801', t0);
    expect(armed.trigger(), '7801');
    expect(armed.trigger(), isNull);
  });
}