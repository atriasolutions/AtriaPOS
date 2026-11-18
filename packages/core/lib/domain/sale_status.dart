import 'failures.dart';

enum SaleStatus {
  confirmada('CONFIRMADA'),
  anulada('ANULADA');

  const SaleStatus(this.apiValue);

  final String apiValue;

  static SaleStatus fromApi(String value) {
    final upper = value.trim().toUpperCase();
    for (final status in SaleStatus.values) {
      if (status.apiValue == upper) return status;
    }
    throw ValidationFailure('Estado de venta no válido: $value');
  }
}