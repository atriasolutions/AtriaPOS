import 'package:core/domain/domain.dart';
import 'package:pos_app/widgets/companion_lan_status_presenter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('SC-111-06 etiqueta celular conectado con modo', () {
    final label = companionLanStatusLabel(
      const CompanionLanStatus(
        storeId: 't1',
        phase: CompanionLanPhase.live,
        mode: CompanionMode.vender,
      ),
    );
    expect(label, contains('Celular conectado'));
    expect(label, contains('Vender'));
  });

  test('SC-111-06 esperando apertura QR en celular', () {
    final label = companionLanStatusLabel(
      const CompanionLanStatus(
        storeId: 't1',
        phase: CompanionLanPhase.sessionOnly,
        mode: CompanionMode.receiptScan,
      ),
    );
    expect(label, contains('Abra el QR en el celular'));
  });

  test('SC-111-06 sin celular', () {
    final label = companionLanStatusLabel(
      const CompanionLanStatus(
        storeId: 't1',
        phase: CompanionLanPhase.none,
      ),
    );
    expect(label, 'Sin celular');
  });

  test('desconectar visible con sesión', () {
    expect(
      shouldShowDisconnectButton(CompanionLanPhase.live),
      isTrue,
    );
    expect(
      shouldShowDisconnectButton(CompanionLanPhase.sessionOnly),
      isTrue,
    );
    expect(
      shouldShowDisconnectButton(CompanionLanPhase.none),
      isFalse,
    );
  });
}