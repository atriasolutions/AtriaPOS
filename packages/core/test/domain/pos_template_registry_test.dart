import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  test('SC-089-02 Atria incluye features R2', () {
    final def = PosTemplateRegistry.resolve(PosTemplateId.atriaPos);
    expect(def.displayName, 'Atria POS');
    expect(def.features, isNot(contains(PosFeature.sellerCodeCheckout)));
    expect(def.features, contains(PosFeature.collaboratorPlanilla));
    expect(def.features, contains(PosFeature.userManagement));
    expect(def.features, contains(PosFeature.storeOperationalConfig));
    expect(def.features, isNot(contains(PosFeature.transbankIntegration)));
    expect(def.features, isNot(contains(PosFeature.trackExpiryOnReceipt)));
  });

  test('SC-089-07 id desconocido → Atria', () {
    expect(PosTemplateId.normalize('NO_EXISTE'), PosTemplateId.atriaPos);
    final tpl = PosTemplateRegistry.resolveNormalized('LEGACY_X');
    expect(tpl.id, PosTemplateId.atriaPos);
  });

  test('SC-089-08 solo ATRIA_POS en bootstrap', () {
    expect(PosTemplateId.isBootstrapAllowed(PosTemplateId.atriaPos), isTrue);
    expect(
      PosTemplateId.isBootstrapAllowed(PosTemplateId.barrioMinTest),
      isFalse,
    );
    expect(
      () => Store.create(
        id: 'x',
        rutRaw: '12.345.678-5',
        legalName: 'X',
        businessLine: 'Y',
        posTemplateId: PosTemplateId.barrioMinTest,
      ),
      throwsA(isA<ValidationFailure>()),
    );
  });
}