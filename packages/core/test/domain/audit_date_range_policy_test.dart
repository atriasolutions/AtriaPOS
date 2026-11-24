import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  test('SC-086-02 acepta rango de 31 días', () {
    final from = DateTime(2026, 3, 1);
    final to = DateTime(2026, 3, 31);
    expect(
      () => AuditDateRangePolicy.validateInclusiveRange(from, to),
      returnsNormally,
    );
  });

  test('SC-086-02 rechaza más de 31 días', () {
    final from = DateTime(2026, 3, 1);
    final to = DateTime(2026, 4, 2);
    expect(
      () => AuditDateRangePolicy.validateInclusiveRange(from, to),
      throwsA(isA<ValidationFailure>()),
    );
  });

  test('SC-086-02 rechaza to antes de from', () {
    expect(
      () => AuditDateRangePolicy.validateInclusiveRange(
        DateTime(2026, 3, 10),
        DateTime(2026, 3, 9),
      ),
      throwsA(isA<ValidationFailure>()),
    );
  });
}