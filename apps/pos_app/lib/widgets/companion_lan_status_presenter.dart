import 'package:core/domain/domain.dart';

import '../companion_mode_labels.dart';

String companionLanStatusLabel(CompanionLanStatus status) {
  return switch (status.phase) {
    CompanionLanPhase.none => 'Sin celular',
    CompanionLanPhase.sessionOnly =>
      status.mode == null
          ? 'Abra el QR en el celular'
          : 'Abra el QR en el celular — ${companionModeCajaLabel(status.mode!)}',
    CompanionLanPhase.live => status.mode == null
        ? 'Celular conectado'
        : 'Celular conectado — ${companionModeCajaLabel(status.mode!)}',
  };
}

bool shouldShowDisconnectButton(CompanionLanPhase phase) =>
    phase == CompanionLanPhase.live ||
    phase == CompanionLanPhase.sessionOnly;

String companionLanServerLabel(bool serverRunning) =>
    serverRunning ? 'Servidor LAN activo' : 'Servidor LAN detenido';