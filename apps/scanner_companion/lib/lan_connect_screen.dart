import 'package:flutter/material.dart';

import 'companion_lan_client.dart';
import 'lan_scan_screen.dart';

/// Pega el enlace del QR del POS y empareja por la red local.
class LanConnectScreen extends StatefulWidget {
  const LanConnectScreen({super.key, required this.client});

  final CompanionLanClient client;

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
              'Pegue el enlace del código QR que muestra el POS.',
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
            FilledButton(
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
