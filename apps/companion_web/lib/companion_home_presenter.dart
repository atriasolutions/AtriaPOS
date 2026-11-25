import 'package:core/domain/domain.dart';

import 'companion_mode_labels.dart';

enum CompanionSessionPhase {
  awaitingQr,
  pairing,
  connected,
  connectionFailed,
}

bool shouldShowScanForm(CompanionSessionPhase phase) =>
    phase == CompanionSessionPhase.connected;

bool shouldShowPairButton(CompanionSessionPhase phase) =>
    phase == CompanionSessionPhase.connectionFailed;

bool shouldShowStoreId(CompanionSessionPhase phase) => false;

bool shouldShowCameraBlock(CompanionSessionPhase phase) =>
    phase == CompanionSessionPhase.connected;

String companionStatusMessage(
  CompanionSessionPhase phase, {
  CompanionMode? mode,
}) {
  return switch (phase) {
    CompanionSessionPhase.awaitingQr =>
      'Escanee el QR del POS para conectar el celular.',
    CompanionSessionPhase.pairing => 'Conectando…',
    CompanionSessionPhase.connected =>
      mode == null
          ? 'Conectado — escriba el código del producto'
          : 'Conectado — ${companionModeCajaLabel(mode)}',
    CompanionSessionPhase.connectionFailed => 'No se pudo conectar al POS',
  };
}