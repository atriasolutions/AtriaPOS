import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  test('SC-089-03 cajero sin userManagement aunque feature activa', () {
    final entries = PosMenuPolicy.visibleForTemplateId(
      UserRole.cajero,
      PosTemplateId.atriaPos,
    );
    expect(
      entries.map((e) => e.feature),
      isNot(contains(PosFeature.userManagement)),
    );
  });

  test('SC-089-02 Atria supervisor incluye ingreso e insights', () {
    final entries = PosMenuPolicy.visibleForTemplateId(
      UserRole.supervisor,
      PosTemplateId.atriaPos,
    );
    final features = entries.map((e) => e.feature).toSet();
    expect(features, contains(PosFeature.stockReceiptGuiaLote));
    expect(features, contains(PosFeature.inventoryClose));
    expect(features, contains(PosFeature.stockInsights));
  });

  test('SC-089-04 feature apagada oculta ítem menú', () {
    final stub = PosTemplateRegistry.resolve(PosTemplateId.barrioMinTest);
    final entries = PosMenuPolicy.visibleEntries(
      UserRole.supervisor,
      stub.toPosTemplate(),
    );
    expect(
      entries.map((e) => e.feature),
      isNot(contains(PosFeature.userManagement)),
    );
    expect(entries.map((e) => e.feature), contains(PosFeature.dailySalesReport));
    expect(
      entries.map((e) => e.feature),
      isNot(contains(PosFeature.stockInsights)),
    );
  });
}