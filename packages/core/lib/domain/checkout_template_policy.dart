import 'pos_feature.dart';
import 'pos_template_id.dart';
import 'pos_template_definition.dart';

class CheckoutTemplatePolicy {
  static bool requiresSellerCode(PosTemplateId templateId) {
    return PosTemplateRegistry.resolve(templateId)
        .features
        .contains(PosFeature.sellerCodeCheckout);
  }

  static bool allowsInvoiceCheckout(PosTemplateId templateId) {
    return PosTemplateRegistry.resolve(templateId)
        .features
        .contains(PosFeature.invoiceCheckout);
  }
}