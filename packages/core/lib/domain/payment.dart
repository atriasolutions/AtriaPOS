import 'failures.dart';
import 'payment_method.dart';

class Payment {
  Payment({
    required this.method,
    required this.amountClp,
  });

  final PaymentMethod method;
  final int amountClp;

  static Payment create({
    required PaymentMethod method,
    required int amountClp,
  }) {
    if (amountClp <= 0) {
      throw const ValidationFailure('El monto del pago debe ser mayor a 0');
    }
    return Payment(method: method, amountClp: amountClp);
  }
}