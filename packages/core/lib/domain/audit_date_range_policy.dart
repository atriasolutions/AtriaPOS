import 'failures.dart';

/// Valida rango calendario local inclusive (máx. 31 días).
class AuditDateRangePolicy {
  static const maxInclusiveDays = 31;

  static void validateInclusiveRange(
    DateTime fromLocalMidnight,
    DateTime toLocalMidnight,
  ) {
    if (toLocalMidnight.isBefore(fromLocalMidnight)) {
      throw const ValidationFailure(
        'La fecha final debe ser igual o posterior a la inicial',
      );
    }
    final days = toLocalMidnight.difference(fromLocalMidnight).inDays + 1;
    if (days > maxInclusiveDays) {
      throw ValidationFailure(
        'El rango de auditoría no puede superar $maxInclusiveDays días',
      );
    }
  }

  /// Fin exclusivo UTC para queries (día final inclusive + 1).
  static DateTime toExclusiveUtc(DateTime toLocalMidnight) {
    final endLocal = DateTime(
      toLocalMidnight.year,
      toLocalMidnight.month,
      toLocalMidnight.day,
    ).add(const Duration(days: 1));
    return endLocal.toUtc();
  }

  static DateTime fromInclusiveUtc(DateTime fromLocalMidnight) {
    return DateTime(
      fromLocalMidnight.year,
      fromLocalMidnight.month,
      fromLocalMidnight.day,
    ).toUtc();
  }
}