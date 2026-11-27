import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  test('SC-145-01 reconoce débito y crédito', () {
    expect(PaymentMethod.fromApi('debito'), PaymentMethod.debito);
    expect(PaymentMethod.fromApi('CREDITO'), PaymentMethod.credito);
    expect(PaymentMethod.debito.apiValue, 'DEBITO');
    expect(PaymentMethod.credito.apiValue, 'CREDITO');
  });
}