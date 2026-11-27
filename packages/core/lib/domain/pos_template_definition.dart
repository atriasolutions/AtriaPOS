import 'pos_feature.dart';
import 'pos_template_id.dart';

class PosTemplate {
  const PosTemplate({
    required this.id,
    required this.displayName,
    required this.features,
  });

  final PosTemplateId id;
  final String displayName;
  final Set<PosFeature> features;

  bool hasFeature(PosFeature feature) => features.contains(feature);
}

class PosTemplateDefinition {
  const PosTemplateDefinition({
    required this.id,
    required this.displayName,
    required this.features,
  });

  final PosTemplateId id;
  final String displayName;
  final Set<PosFeature> features;

  PosTemplate toPosTemplate() => PosTemplate(
        id: id,
        displayName: displayName,
        features: features,
      );
}

class PosTemplateRegistry {
  /// SLICE-144 / DEC-066: `sellerCodeCheckout` queda fuera de Atria hasta retomar RF-084.
  /// La planilla (`collaboratorPlanilla`) se mantiene.
  static const _atriaFeatures = {
    PosFeature.collaboratorPlanilla,
    PosFeature.stockReceiptGuiaLote,
    PosFeature.auditTrail,
    PosFeature.stockInsights,
    PosFeature.inventoryClose,
    PosFeature.dteQueue,
    PosFeature.fiscalCertificate,
    PosFeature.dailySalesReport,
    PosFeature.shiftSalesList,
    PosFeature.closeShift,
    PosFeature.stockAdjust,
    PosFeature.productCreate,
    PosFeature.userManagement,
    PosFeature.invoiceCheckout,
  };

  static PosTemplateDefinition resolve(PosTemplateId id) {
    return switch (id) {
      PosTemplateId.atriaPos => const PosTemplateDefinition(
          id: PosTemplateId.atriaPos,
          displayName: 'Atria POS',
          features: _atriaFeatures,
        ),
      PosTemplateId.barrioMinTest => const PosTemplateDefinition(
          id: PosTemplateId.barrioMinTest,
          displayName: 'Barrio mínimo test',
          features: {
            PosFeature.shiftSalesList,
            PosFeature.closeShift,
            PosFeature.dailySalesReport,
            PosFeature.stockAdjust,
          },
        ),
    };
  }

  static PosTemplate resolveNormalized(String? rawTemplateId) {
    return resolve(PosTemplateId.normalize(rawTemplateId)).toPosTemplate();
  }
}