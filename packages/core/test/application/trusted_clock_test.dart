import 'package:core/application/ports/trusted_clock.dart';
import 'package:test/test.dart';

void main() {
  test('SC-015-01 FakeTrustedClock retorna instante fijo', () {
    final fixed = DateTime.utc(2026, 3, 18, 15, 30, 0);
    final clock = FakeTrustedClock(fixed);
    expect(clock.now(), fixed);
    expect(clock.isDegraded, isFalse);
  });

  test('MutableTrustedClock aplica offset', () {
    final clock = MutableTrustedClock(offset: const Duration(hours: 1));
    final before = DateTime.now().toUtc();
    final observed = clock.now();
    expect(observed.isAfter(before.add(const Duration(minutes: 59))), isTrue);
  });
}