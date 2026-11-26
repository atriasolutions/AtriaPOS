import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;
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

/// Aviso cuando la IP del QR no coincide con el certificado guardado (SLICE-129).
const companionCertIpMismatchMessage =
    'La IP de red ya no coincide con el certificado HTTPS.\n'
    '1. Cierre este diálogo.\n'
    '2. Reinicie el POS.\n'
    '3. Vuelva a abrir el QR del companion.\n'
    'Opcional: fije COMPANION_LAN_HOST con la IPv4 de ipconfig.';

class CompanionQrPanel extends StatefulWidget {
  @visibleForTesting
  static bool suppressQrImageForTests = false;

  @visibleForTesting
  static bool suppressPhoneStatusForTests = false;

  const CompanionQrPanel({
    super.key,
    required this.composition,
    required this.mode,
    required this.qrKey,
    this.statusKey,
    this.qrFutureForTests,
  });

  final PosComposition composition;
  final CompanionMode mode;
  final Key qrKey;
  final Key? statusKey;

  @visibleForTesting
  final Future<CompanionQrState?>? qrFutureForTests;

  @override
  State<CompanionQrPanel> createState() => _CompanionQrPanelState();
}

class _CompanionQrPanelState extends State<CompanionQrPanel> {
  late Future<CompanionQrState?> _qrFuture;
  late final Stream<CompanionLanStatus> _statusStream;

  @override
  void initState() {
    super.initState();
    _qrFuture =
        widget.qrFutureForTests ??
        widget.composition.prepareCompanionQr(widget.mode);
    _statusStream = widget.composition.companionLanStatusStream();
  }

  void _refreshQr() {
    setState(() {
      _qrFuture = widget.composition.prepareCompanionQr(widget.mode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CompanionQrState?>(
      future: _qrFuture,
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
            if (CompanionQrPanel.suppressQrImageForTests)
              SizedBox(key: widget.qrKey, height: 200, width: 200)
            else
              QrImageView(
                key: widget.qrKey,
                data: state.launchUrl!,
                version: QrVersions.auto,
                size: 200,
              ),
            const SizedBox(height: 8),
            Text(
              'Código: ${state.pairingCode}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (state.advertisedHost != null) ...[
              const SizedBox(height: 4),
              Text(
                _networkLabel(state),
                key: const Key('companion_advertised_host'),
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
            if (widget.statusKey != null)
              Text(
                key: widget.statusKey,
                companionLanServerLabel(state.serverRunning),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            if (!CompanionQrPanel.suppressPhoneStatusForTests) ...[
              const SizedBox(height: 12),
              StreamBuilder<CompanionLanStatus>(
                stream: _statusStream,
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
                            await widget.composition.disconnectCompanionLan();
                          },
                          child: const Text('Desconectar celular'),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ],
            const SizedBox(height: 8),
            OutlinedButton(
              key: const Key('companion_qr_refresh_button'),
              onPressed: _refreshQr,
              child: const Text('Actualizar código'),
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
              CompanionCertIpMismatchHint(
                key: const Key('companion_cert_ip_mismatch'),
              ),
            ],
          ],
        );
      },
    );
  }

  String _networkLabel(CompanionQrState state) {
    final host = state.advertisedHost!;
    final iface = state.advertisedInterface;
    if (iface == null || iface.isEmpty) {
      return 'Red: $host';
    }
    return 'Red: $host ($iface)';
  }
}

class CompanionCertIpMismatchHint extends StatelessWidget {
  const CompanionCertIpMismatchHint({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        companionCertIpMismatchMessage,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colors.onErrorContainer,
            ),
        textAlign: TextAlign.start,
      ),
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
    this.advertisedHost,
    this.advertisedInterface,
  });

  const CompanionQrState.blocked({
    required CompanionQrBlockedReason reason,
    required bool serverRunning,
  })  : launchUrl = null,
        pairingCode = null,
        serverRunning = serverRunning,
        blockedReason = reason,
        caInstallUrl = null,
        certIpMismatch = false,
        advertisedHost = null,
        advertisedInterface = null;

  final String? launchUrl;
  final String? pairingCode;
  final bool serverRunning;
  final CompanionQrBlockedReason? blockedReason;
  final String? caInstallUrl;
  final bool certIpMismatch;
  final String? advertisedHost;
  final String? advertisedInterface;
}