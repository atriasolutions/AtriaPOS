import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  test('formatChileDateTime fecha y hora', () {
    final instant = DateTime.utc(2026, 3, 18, 15, 0, 0);
    expect(formatChileDateTime(instant), '18/03/2026 15:00:00');
    expect(formatChileDate(instant), '18/03/2026');
    expect(formatChileTime(instant), '15:00:00');
    expect(formatChileTimeHm(instant), '15:00');
    expect(formatChileStripDate(instant), '18-Mar-26');
    expect(formatChileStripTime(instant), '3:00 PM');
  });
}