import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../di/pos_composition.dart';

/// URL de emparejamiento para PWA companion (doc 07).
String buildCompanionLaunchUrl({
  required Uri base,
  required String storeId,
  required CompanionMode mode,
  required String pairingCode,
}) {
  return base
      .replace(
        path: '/companion/',
        queryParameters: {
          'storeId': storeId,
          'mode': mode.apiValue,
          'pairingCode': pairingCode,
        },
      )
      .toString();
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
                state.serverRunning
                    ? 'Companion LAN activo'
                    : 'Companion LAN detenido',
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