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

    test('nunca muestra bloque de cámara en slice 108', () {
      for (final phase in CompanionSessionPhase.values) {
        expect(shouldShowCameraBlock(phase), isFalse);
      }
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