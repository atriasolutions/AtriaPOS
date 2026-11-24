import 'audit_date_range_policy.dart';

/// Ventana fija de 30 días calendario inclusive terminando en [asOfLocalMidnight].
class TopSalesPeriodPolicy {
  static const periodDays = 30;

  static DateTime fromLocalMidnight(DateTime asOfLocalMidnight) {
    final anchor = DateTime(
      asOfLocalMidnight.year,
      asOfLocalMidnight.month,
      asOfLocalMidnight.day,
    );
    return anchor.subtract(const Duration(days: periodDays - 1));
  }

  static DateTime fromInclusiveUtc(DateTime asOfLocalMidnight) {
    return AuditDateRangePolicy.fromInclusiveUtc(
      fromLocalMidnight(asOfLocalMidnight),
    );
  }

  static DateTime toExclusiveUtc(DateTime asOfLocalMidnight) {
    return AuditDateRangePolicy.toExclusiveUtc(asOfLocalMidnight);
  }
}