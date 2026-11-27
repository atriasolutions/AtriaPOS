import 'pos_feature.dart';
import 'pos_template_id.dart';
import 'pos_template_definition.dart';

class CheckoutTemplatePolicy {
  static bool requiresSellerCode(PosTemplateId templateId) {
    return requiresSellerCodeTemplate(
      PosTemplateRegistry.resolve(templateId).toPosTemplate(),
    );
  }

  static bool allowsInvoiceCheckout(PosTemplateId templateId) {
    return allowsInvoiceCheckoutTemplate(
      PosTemplateRegistry.resolve(templateId).toPosTemplate(),
    );
  }

  static bool requiresSellerCodeTemplate(PosTemplate template) {
    return template.hasFeature(PosFeature.sellerCodeCheckout);
  }

  static bool allowsInvoiceCheckoutTemplate(PosTemplate template) {
    return template.hasFeature(PosFeature.invoiceCheckout);
  }
}