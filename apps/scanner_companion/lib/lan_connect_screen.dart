import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'companion_lan_client.dart';
import 'companion_qr_link.dart';
import 'lan_scan_screen.dart';

/// Lee el QR del POS o pega el enlace, y empareja por la red local.
class LanConnectScreen extends StatefulWidget {
  const LanConnectScreen({super.key, required this.client, this.qrReader});

  final CompanionLanClient client;

  /// Sustituye la cámara en pruebas. Recibe el texto leído.
  final Widget Function(void Function(String value) onCode)? qrReader;

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
    final value = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (routeContext) {
          void accept(String raw) {
            if (parseCompanionQrLink(raw) == null) return;
            Navigator.of(routeContext).pop(raw.trim());
          }

          final reader = widget.qrReader;
          return Scaffold(
            appBar: AppBar(title: const Text('Apunte al QR del POS')),
            body: reader != null
                ? reader(accept)
                : MobileScanner(
                    onDetect: (capture) {
                      final raw = capture.barcodes.firstOrNull?.rawValue;
                      if (raw != null) accept(raw);
                    },
                  ),
          );
        },
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
