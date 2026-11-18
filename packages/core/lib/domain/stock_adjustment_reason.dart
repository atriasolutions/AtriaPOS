import 'failures.dart';

enum StockAdjustmentReason {
  merma('MERMA'),
  ajuste('AJUSTE'),
  recepcion('RECEPCION'),
  correccion('CORRECCION'),
  venta('VENTA');

  const StockAdjustmentReason(this.apiValue);

  final String apiValue;

  static StockAdjustmentReason fromApi(String value) {
    final upper = value.trim().toUpperCase();
    for (final reason in StockAdjustmentReason.values) {
      if (reason.apiValue == upper) return reason;
    }
    throw ValidationFailure('Motivo de ajuste no válido: $value');
  }
}