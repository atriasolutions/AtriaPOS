import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  test('SC-144-01 Atria no exige sellerCode mientras RF-084 está en pausa', () {
    expect(
      CheckoutTemplatePolicy.requiresSellerCode(PosTemplateId.atriaPos),
      isFalse,
    );
    expect(
      PosTemplateRegistry.resolve(PosTemplateId.atriaPos).features,
      contains(PosFeature.collaboratorPlanilla),
    );
  });

  test('plantilla mínima test no exige sellerCode', () {
    expect(
      CheckoutTemplatePolicy.requiresSellerCode(PosTemplateId.barrioMinTest),
      isFalse,
    );
  });

  test('SC-093 Atria permite factura en checkout', () {
    expect(
      CheckoutTemplatePolicy.allowsInvoiceCheckout(PosTemplateId.atriaPos),
      isTrue,
    );
    expect(
      CheckoutTemplatePolicy.allowsInvoiceCheckout(PosTemplateId.barrioMinTest),
      isFalse,
    );
  });
}