import 'failures.dart';

enum PaymentMethod {
  efectivo('EFECTIVO'),
  debito('DEBITO'),
  credito('CREDITO'),
  otro('OTRO');

  const PaymentMethod(this.apiValue);

  final String apiValue;

  static PaymentMethod fromApi(String value) {
    final upper = value.trim().toUpperCase();
    for (final method in PaymentMethod.values) {
      if (method.apiValue == upper) return method;
    }
    throw ValidationFailure('Medio de pago no válido: $value');
  }
}