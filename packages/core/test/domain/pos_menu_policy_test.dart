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
  });
}