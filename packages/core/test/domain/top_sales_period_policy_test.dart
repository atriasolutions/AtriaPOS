import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  test('SC-087-08 ventana 30 días hasta asOf', () {
    final asOf = DateTime(2026, 3, 18);
    final fromLocal = TopSalesPeriodPolicy.fromLocalMidnight(asOf);
    expect(fromLocal, DateTime(2026, 2, 17));
    expect(TopSalesPeriodPolicy.periodDays, 30);
  });
}