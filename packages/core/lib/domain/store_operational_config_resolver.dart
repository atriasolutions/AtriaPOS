import 'pos_feature.dart';
import 'pos_template_definition.dart';
import 'store.dart';
import 'store_operational_overrides.dart';

/// Merge plantilla + overrides (DEC-067).
class StoreOperationalConfigResolver {
  static PosTemplate effectiveTemplate(Store store) {
    final base = PosTemplateRegistry.resolve(store.posTemplateId);
    var features = Set<PosFeature>.from(base.features);
    final overrides = store.operationalOverrides;
    if (overrides == null) {
      return PosTemplate(
        id: base.id,
        displayName: base.displayName,
        features: features,
      );
    }

    void apply(PosFeature feature, bool? enabled) {
      if (enabled == null) return;
      if (enabled) {
        features.add(feature);
      } else {
        features.remove(feature);
      }
    }

    apply(PosFeature.sellerCodeCheckout, overrides.sellerCodeRequired);
    apply(PosFeature.invoiceCheckout, overrides.invoiceCheckoutEnabled);
    apply(PosFeature.transbankIntegration, overrides.transbankEnabled);
    apply(PosFeature.stockReceiptGuiaLote, overrides.receiptRequiresGuiaLote);
    apply(PosFeature.trackExpiryOnReceipt, overrides.trackExpiryOnReceipt);
    apply(PosFeature.inventoryClose, overrides.inventoryCloseEnabled);

    final dte = overrides.dteEnabled;
    if (dte != null) {
      if (dte) {
        features.add(PosFeature.dteQueue);
        features.add(PosFeature.fiscalCertificate);
      } else {
        features.remove(PosFeature.dteQueue);
        features.remove(PosFeature.fiscalCertificate);
      }
    }

    return PosTemplate(
      id: base.id,
      displayName: base.displayName,
      features: features,
    );
  }
}