import 'package:core/domain/domain.dart';
import 'package:flutter/material.dart';

import 'companion_client.dart';

void main() {
  runApp(const CompanionWebApp());
}

class CompanionWebApp extends StatelessWidget {
  const CompanionWebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Atria Companion',
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: const CompanionHomeScreen(),
    );
  }
}

class CompanionHomeScreen extends StatefulWidget {
  const CompanionHomeScreen({super.key});

  @override
  State<CompanionHomeScreen> createState() => _CompanionHomeScreenState();
}

class _CompanionHomeScreenState extends State<CompanionHomeScreen> {
  CompanionLaunchParams? _params;
  CompanionClient? _client;
  String _status = 'Abra el enlace del QR del POS';
  final _codeController = TextEditingController();
  String? _error;

  @override
  void initState() {
    super.initState();
    _readLaunchUri();
  }

  void _readLaunchUri() {
    try {
      final uri = Uri.base;
      if (uri.queryParameters.containsKey('pairingCode')) {
        _params = CompanionLaunchParams.fromUri(uri);
        _status = 'Listo para emparejar (${_params!.mode.apiValue})';
      }
    } catch (e) {
      _error = e.toString();
    }
  }

  Future<void> _connect() async {
    final params = _params;
    if (params == null) return;
    setState(() {
      _status = 'Emparejando…';
      _error = null;
    });
    final client = CompanionClient(http.Client());
    try {
      await client.pair(params);
      _client = client;
      setState(() => _status = 'Conectado — ingrese un código o use la cámara');
    } catch (e) {
      setState(() {
        _error = e.toString();
        _status = 'Error de conexión';
      });
      client.dispose();
    }
  }

  Future<void> _sendCode() async {
    final client = _client;
    if (client == null) return;
    final code = _codeController.text.trim();
    if (code.isEmpty) return;
    await client.sendScan(code);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Enviado: $code')),
    );
    _codeController.clear();
  }

  @override
  void dispose() {
    _client?.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final params = _params;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atria Companion'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(_status, key: const Key('companion_status_label')),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
            if (params != null) ...[
              const SizedBox(height: 12),
              Text('Tienda: ${params.storeId}'),
              Text('Modo: ${params.mode.apiValue}'),
              const SizedBox(height: 12),
              FilledButton(
                key: const Key('companion_pair_button'),
                onPressed: _client == null ? _connect : null,
                child: const Text('Emparejar'),
              ),
            ],
            const SizedBox(height: 24),
            TextField(
              key: const Key('companion_manual_code_field'),
              controller: _codeController,
              decoration: const InputDecoration(
                labelText: 'Código de barras',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _sendCode(),
            ),
            const SizedBox(height: 8),
            FilledButton(
              key: const Key('companion_send_scan_button'),
              onPressed: _client == null ? null : _sendCode,
              child: const Text('Enviar escaneo'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Cámara: habilitar en dispositivo Android (SLICE-95b). '
              'MVP usa ingreso manual como respaldo.',
            ),
          ],
        ),
      ),
    );
  }
}