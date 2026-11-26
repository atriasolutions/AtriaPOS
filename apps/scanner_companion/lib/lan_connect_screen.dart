import 'package:flutter/material.dart';

import 'companion_camera_view.dart';
import 'companion_lan_client.dart';
import 'companion_qr_link.dart';
import 'lan_scan_screen.dart';

/// Lee el QR del POS o pega el enlace, y empareja por la red local.
class LanConnectScreen extends StatefulWidget {
  const LanConnectScreen({
    super.key,
    required this.client,
    this.qrReader,
    this.ensureCamera,
    this.openSettings,
  });

  final CompanionLanClient client;

  /// Sustituye la cámara en pruebas. Recibe el texto leído.
  final Widget Function(void Function(String value) onCode)? qrReader;

  /// True si el usuario concedió la cámara. En pruebas se inyecta.
  final Future<bool> Function()? ensureCamera;

  /// Abre los ajustes de la app. En pruebas se inyecta.
  final Future<void> Function()? openSettings;

  @override
  State<LanConnectScreen> createState() => _LanConnectScreenState();
}

class _LanConnectScreenState extends State<LanConnectScreen> {
  final _url = TextEditingController();
  String? _error;
  String? _modeLabel;
  CompanionLanSession? _session;
  bool _busy = false;

  @override
  void dispose() {
    _url.dispose();
    super.dispose();
  }

  Future<void> _connect() async {
    if (_url.text.trim().isEmpty) {
      setState(() => _error = 'Lea el QR del POS o pegue el enlace.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
      _modeLabel = null;
    });
    try {
      final session = await widget.client.connectLink(_url.text);
      if (!mounted) return;
      setState(() {
        _session = session;
        _modeLabel = companionLanModeLabel(session.modeApi);
        _busy = false;
      });
    } on CompanionLinkRejected {
      if (!mounted) return;
      setState(() {
        _error = 'Enlace no válido o expirado';
        _busy = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'No se pudo conectar al POS';
        _busy = false;
      });
    }
  }

  Future<void> _readQr() async {
    final allowed = await (widget.ensureCamera ?? ensureCompanionCamera)();
    if (!mounted) return;
    if (!allowed) {
      setState(() => _error = cameraPermissionMessage);
      return;
    }
    final value = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(
        builder: (_) => _CompanionQrScanPage(qrReader: widget.qrReader),
      ),
    );
    if (!mounted || value == null || value.isEmpty) return;
    _url.text = value;
    await _connect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conectar al POS')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Lea el código QR de la pantalla del POS, o pegue el enlace.',
            ),
            const SizedBox(height: 16),
            FilledButton(
              key: const Key('companion_lan_read_qr_button'),
              onPressed: _busy ? null : _readQr,
              child: const Text('Leer QR del POS'),
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key('companion_lan_url_field'),
              controller: _url,
              decoration: const InputDecoration(
                labelText: 'Enlace del QR',
                border: OutlineInputBorder(),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(
                _error!,
                key: const Key('companion_lan_error'),
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              if (_error == cameraPermissionMessage) ...[
                const SizedBox(height: 8),
                OutlinedButton(
                  key: const Key('companion_camera_settings_button'),
                  onPressed: () {
                    final open = widget.openSettings ?? openCompanionCameraSettings;
                    open();
                  },
                  child: const Text('Abrir ajustes de la app'),
                ),
              ],
            ],
            if (_modeLabel != null) ...[
              const SizedBox(height: 12),
              Text(
                'Conectado · $_modeLabel',
                key: const Key('companion_lan_status'),
              ),
            ],
            const SizedBox(height: 16),
            OutlinedButton(
              key: const Key('companion_lan_connect_button'),
              onPressed: _busy ? null : _connect,
              child: const Text('Conectar'),
            ),
            if (_session != null) ...[
              const SizedBox(height: 12),
              FilledButton(
                key: const Key('companion_lan_scan_button'),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => LanScanScreen(session: _session!),
                    ),
                  );
                },
                child: const Text('Escanear productos'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Lectura única del QR: evita varios `pop` si el escáner repite el código.
class _CompanionQrScanPage extends StatefulWidget {
  const _CompanionQrScanPage({this.qrReader});

  final Widget Function(void Function(String value) onCode)? qrReader;

  @override
  State<_CompanionQrScanPage> createState() => _CompanionQrScanPageState();
}

class _CompanionQrScanPageState extends State<_CompanionQrScanPage> {
  var _handled = false;

  void _accept(String raw) {
    if (_handled) return;
    if (parseCompanionQrLink(raw) == null) return;
    _handled = true;
    final nav = Navigator.of(context);
    if (!nav.canPop()) return;
    nav.pop(raw.trim());
  }

  @override
  Widget build(BuildContext context) {
    final reader = widget.qrReader;
    return Scaffold(
      appBar: AppBar(title: const Text('Apunte al QR del POS')),
      body: reader != null
          ? reader(_accept)
          : CompanionCameraView(
              onlyPairingLink: true,
              onCode: _accept,
            ),
    );
  }
}
