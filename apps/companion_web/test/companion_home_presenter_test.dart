import 'package:companion_web/companion_home_presenter.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  group('SC-108-02 visibilidad UI', () {
    test('sin parámetros QR no muestra formulario de escaneo', () {
      expect(shouldShowScanForm(CompanionSessionPhase.awaitingQr), isFalse);
    });

    test('conectado muestra formulario de escaneo', () {
      expect(shouldShowScanForm(CompanionSessionPhase.connected), isTrue);
    });

    test('no muestra botón emparejar salvo error de conexión', () {
      expect(shouldShowPairButton(CompanionSessionPhase.awaitingQr), isFalse);
      expect(shouldShowPairButton(CompanionSessionPhase.pairing), isFalse);
      expect(shouldShowPairButton(CompanionSessionPhase.connected), isFalse);
      expect(
        shouldShowPairButton(CompanionSessionPhase.connectionFailed),
        isTrue,
      );
    });

    test('SC-110-01 cámara solo si conectado', () {
      expect(shouldShowCameraBlock(CompanionSessionPhase.connected), isTrue);
    });

    test('SC-110-02 sin cámara antes de conectar o tras fallo', () {
      expect(shouldShowCameraBlock(CompanionSessionPhase.awaitingQr), isFalse);
      expect(shouldShowCameraBlock(CompanionSessionPhase.pairing), isFalse);
      expect(
        shouldShowCameraBlock(CompanionSessionPhase.connectionFailed),
        isFalse,
      );
    });

    test('nunca muestra UUID de tienda', () {
      for (final phase in CompanionSessionPhase.values) {
        expect(shouldShowStoreId(phase), isFalse);
      }
    });
  });

  group('mensajes de estado', () {
    test('esperando QR', () {
      expect(
        companionStatusMessage(CompanionSessionPhase.awaitingQr),
        contains('QR'),
      );
    });

    test('conectado sin mencionar cámara', () {
      final msg = companionStatusMessage(
        CompanionSessionPhase.connected,
        mode: CompanionMode.vender,
      );
      expect(msg, contains('Vender'));
      expect(msg.toLowerCase(), isNot(contains('cámara')));
    });
  });
}