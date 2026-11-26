import 'package:flutter_test/flutter_test.dart';
import 'package:scanner_companion/companion_armed_scan.dart';

void main() {
  final t0 = DateTime.utc(2026, 11, 26, 12);

  test('SC-131-01 dos detecciones iguales no disparan envío', () {
    final armed = CompanionArmedScan();
    expect(armed.onDetect('7801', t0), isTrue);
    expect(armed.onDetect('7801', t0), isFalse);
    expect(armed.pending, '7801');
  });

  test('SC-131-02 trigger envía una vez y limpia el buffer', () {
    final armed = CompanionArmedScan();
    armed.onDetect('7801', t0);
    expect(armed.trigger(), '7801');
    expect(armed.trigger(), isNull);
    expect(armed.pending, isNull);
  });

  test('SC-131-03 códigos distintos requieren trigger entre medio', () {
    final armed = CompanionArmedScan();
    armed.onDetect('111', t0);
    expect(armed.trigger(), '111');
    armed.onDetect('222', t0);
    expect(armed.trigger(), '222');
  });

  test('SC-131-04 trigger sin detección no entrega código', () {
    final armed = CompanionArmedScan();
    expect(armed.trigger(), isNull);
  });
}
