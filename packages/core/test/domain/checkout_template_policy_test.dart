import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  test('SC-089-05 Atria exige sellerCode', () {
    expect(
      CheckoutTemplatePolicy.requiresSellerCode(PosTemplateId.atriaPos),
      isTrue,
    );
  });

  test('plantilla mínima test no exige sellerCode', () {
    expect(
      CheckoutTemplatePolicy.requiresSellerCode(PosTemplateId.barrioMinTest),
      isFalse,
    );
  });
}