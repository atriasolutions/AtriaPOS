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
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            QrImageView(
              key: qrKey,
              data: state.launchUrl,
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
              state.launchUrl,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        );
      },
    );
  }
}

class CompanionQrState {
  const CompanionQrState({
    required this.launchUrl,
    required this.pairingCode,
    required this.serverRunning,
  });

  final String launchUrl;
  final String pairingCode;
  final bool serverRunning;
}