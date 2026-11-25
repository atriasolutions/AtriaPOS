import 'dart:async';

import 'package:core/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'companion_client.dart';
import 'companion_home_presenter.dart';
import 'companion_mode_labels.dart';

typedef CompanionPairFn = Future<CompanionClient> Function(
  CompanionLaunchParams params,
);

CompanionLaunchParams? readCompanionLaunchParams(Uri uri) {
  try {
    if (uri.queryParameters.containsKey('pairingCode')) {
      return CompanionLaunchParams.fromUri(uri);
    }
  } on ArgumentError {
    return null;
  }
  return null;
}

class CompanionHomeScreen extends StatefulWidget {
  const CompanionHomeScreen({
    super.key,
    this.launchUri,
    this.pairFn,
  });

  /// Solo tests: simula la URL tras el redirect `/companion/?…`.
  final Uri? launchUri;

  /// Solo tests: evita red real al emparejar.
  final CompanionPairFn? pairFn;

  @override
  State<CompanionHomeScreen> createState() => _CompanionHomeScreenState();
}

class _CompanionHomeScreenState extends State<CompanionHomeScreen> {
  CompanionLaunchParams? _params;
  CompanionClient? _client;
  CompanionSessionPhase _phase = CompanionSessionPhase.awaitingQr;
  final _codeController = TextEditingController();
  String? _error;

  @override
  void initState() {
    super.initState();
    final uri = widget.launchUri ?? Uri.base;
    _params = readCompanionLaunchParams(uri);
    if (_params != null) {
      _phase = CompanionSessionPhase.pairing;
      unawaited(_connect());
    }
  }

  Future<CompanionClient> _defaultPair(CompanionLaunchParams params) async {
    final client = CompanionClient(http.Client());
    await client.pair(params);
    return client;
  }

  Future<void> _connect() async {
    final params = _params;
    if (params == null) return;
    setState(() {
      _phase = CompanionSessionPhase.pairing;
      _error = null;
    });
    final pair = widget.pairFn ?? _defaultPair;
    try {
      final client = await pair(params);
      if (!mounted) {
        client.dispose();
        return;
      }
      setState(() {
        _client = client;
        _phase = CompanionSessionPhase.connected;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _phase = CompanionSessionPhase.connectionFailed;
      });
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
    final mode = params?.mode;
    final status = companionStatusMessage(_phase, mode: mode);
    final showScan = shouldShowScanForm(_phase);
    final showRetry = shouldShowPairButton(_phase);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Atria Companion'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(status, key: const Key('companion_status_label')),
            if (mode != null && _phase != CompanionSessionPhase.awaitingQr) ...[
              const SizedBox(height: 8),
              Text(
                'Modo: ${companionModeCajaLabel(mode)}',
                key: const Key('companion_mode_label'),
              ),
            ],
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(
                _error!,
                key: const Key('companion_error_label'),
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            if (showRetry) ...[
              const SizedBox(height: 12),
              FilledButton(
                key: const Key('companion_pair_button'),
                onPressed: _connect,
                child: const Text('Reintentar'),
              ),
            ],
            if (showScan) ...[
              const SizedBox(height: 24),
              const Text(
                'Escriba o pegue el código de barras del producto',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 12),
              TextField(
                key: const Key('companion_manual_code_field'),
                controller: _codeController,
                style: const TextStyle(fontSize: 22),
                decoration: const InputDecoration(
                  labelText: 'Código de barras',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                ),
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendCode(),
              ),
              const SizedBox(height: 12),
              FilledButton(
                key: const Key('companion_send_scan_button'),
                onPressed: _sendCode,
                child: const Text('Enviar escaneo'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}