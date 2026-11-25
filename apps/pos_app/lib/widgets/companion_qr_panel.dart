import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../di/pos_composition.dart';
import 'companion_lan_status_presenter.dart';

/// URL corta del QR (DEC-060, SLICE-107).
String buildCompanionLaunchUrl({
  required Uri base,
  required String pairingCode,
}) {
  return buildCompanionShortLinkUrl(base: base, pairingCode: pairingCode);
}

class CompanionQrPanel extends StatelessWidget {
  const CompanionQrPanel({
    super.key,
    required this.composition,
    required this.mode,
    required this.qrKey,
    this.statusKey,
  });

  final PosComposition composition;
  final CompanionMode mode;
  final Key qrKey;
  final Key? statusKey;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CompanionQrState?>(
      future: composition.prepareCompanionQr(mode),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        final state = snapshot.data;
        if (state == null) {
          return const Text('No se pudo iniciar companion LAN.');
        }
        if (state.blockedReason == CompanionQrBlockedReason.pwaMissing) {
          return const CompanionPwaMissingInstructions();
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            QrImageView(
              key: qrKey,
              data: state.launchUrl!,
              version: QrVersions.auto,
              size: 200,
            ),
            const SizedBox(height: 8),
            Text(
              'Código: ${state.pairingCode}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (statusKey != null)
              Text(
                key: statusKey,
                companionLanServerLabel(state.serverRunning),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            const SizedBox(height: 12),
            StreamBuilder<CompanionLanStatus>(
              stream: composition.companionLanStatusStream(),
              builder: (context, statusSnap) {
                final status = statusSnap.data;
                if (status == null || status.phase == CompanionLanPhase.none) {
                  return Text(
                    companionLanStatusLabel(
                      const CompanionLanStatus(
                        storeId: '',
                        phase: CompanionLanPhase.none,
                      ),
                    ),
                    key: const Key('companion_phone_status'),
                  );
                }
                return Column(
                  children: [
                    Text(
                      key: const Key('companion_phone_status'),
                      companionLanStatusLabel(status),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    if (shouldShowDisconnectButton(status.phase)) ...[
                      const SizedBox(height: 8),
                      OutlinedButton(
                        key: const Key('companion_disconnect_button'),
                        onPressed: () async {
                          await composition.disconnectCompanionLan();
                        },
                        child: const Text('Desconectar celular'),
                      ),
                    ],
                  ],
                );
              },
            ),
            const SizedBox(height: 4),
            Text(
              state.launchUrl!,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            if (state.caInstallUrl != null) ...[
              const SizedBox(height: 12),
              CompanionCaInstallHint(installUrl: state.caInstallUrl!),
            ],
            if (state.certIpMismatch) ...[
              const SizedBox(height: 8),
              Text(
                key: const Key('companion_cert_ip_mismatch'),
                'La IP de red cambió respecto al certificado. '
                'Reinicie el POS o fije COMPANION_LAN_HOST.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        );
      },
    );
  }
}

enum CompanionQrBlockedReason { pwaMissing }

/// Primera conexión HTTPS: instalar CA en el celular (SLICE-114).
class CompanionCaInstallHint extends StatelessWidget {
  const CompanionCaInstallHint({super.key, required this.installUrl});

  final String installUrl;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodySmall;
    return Column(
      key: const Key('companion_ca_install_hint'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Primera vez en el celular: abra esta página e instale el certificado.',
          style: style,
        ),
        const SizedBox(height: 4),
        SelectableText(installUrl, style: style),
      ],
    );
  }
}

/// Instrucciones cuando falta el build de companion_web (SLICE-113).
class CompanionPwaMissingInstructions extends StatelessWidget {
  const CompanionPwaMissingInstructions({super.key});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium;
    return Column(
      key: const Key('companion_pwa_missing'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Falta el build de Companion (PWA).', style: style),
        const SizedBox(height: 8),
        Text(
          '1. En la raíz del repo ejecute .\\scripts\\prepare-companion-pwa.ps1',
          style: style,
        ),
        Text(
          '2. Arranque el POS con el comando que imprime el script '
          '(COMPANION_WEB_ROOT y puerto 8765).',
          style: style,
        ),
        const SizedBox(height: 8),
        Text(
          'Vuelva a abrir este diálogo después de reiniciar.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class CompanionQrState {
  const CompanionQrState({
    required this.launchUrl,
    required this.pairingCode,
    required this.serverRunning,
    this.blockedReason,
    this.caInstallUrl,
    this.certIpMismatch = false,
  });

  const CompanionQrState.blocked({
    required CompanionQrBlockedReason reason,
    required bool serverRunning,
  })  : launchUrl = null,
        pairingCode = null,
        serverRunning = serverRunning,
        blockedReason = reason,
        caInstallUrl = null,
        certIpMismatch = false;

  final String? launchUrl;
  final String? pairingCode;
  final bool serverRunning;
  final CompanionQrBlockedReason? blockedReason;
  final String? caInstallUrl;
  final bool certIpMismatch;
}