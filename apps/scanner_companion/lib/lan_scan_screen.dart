import 'package:flutter/material.dart';

import 'companion_armed_scan.dart';
import 'companion_camera_view.dart';
import 'companion_lan_client.dart';
import 'companion_ui_strings.dart';

/// Visor de productos. [camera] permite pruebas sin abrir la cámara real.
class LanScanScreen extends StatefulWidget {
  const LanScanScreen({
    super.key,
    required this.session,
    this.camera,
    this.now,
  });

  final CompanionLanSession session;
  final Widget Function(void Function(String code) onCode)? camera;
  final DateTime Function()? now;

  @override
  State<LanScanScreen> createState() => _LanScanScreenState();
}

class _LanScanScreenState extends State<LanScanScreen> {
  final _armed = CompanionArmedScan();
  String? _lastSent;

  DateTime _now() => widget.now?.call() ?? DateTime.now();

  bool get _hasPending => _armed.pending != null;

  void handleCode(String raw) {
    if (!_armed.onDetect(raw, _now())) return;
    setState(() {});
  }

  void _send() {
    final code = _armed.trigger();
    if (code == null) return;
    widget.session.sendScan(code);
    setState(() => _lastSent = code);
  }

  String get _statusText {
    final pending = _armed.pending;
    if (pending != null) return 'Listo: $pending';
    if (_lastSent != null) return 'Último: $_lastSent';
    return companionAimBarcodeHint;
  }

  @override
  Widget build(BuildContext context) {
    final camera = widget.camera;
    return Scaffold(
      appBar: AppBar(
        title: Text(companionLanModeLabel(widget.session.modeApi)),
        actions: [
          TextButton(
            key: const Key('companion_lan_disconnect_button'),
            onPressed: () {
              final nav = Navigator.of(context);
              if (nav.canPop()) nav.pop();
            },
            child: const Text(companionLeaveBoxButtonLabel),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: camera != null
                ? camera(handleCode)
                : CompanionCameraView(onCode: handleCode),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_hasPending)
                    Align(
                      child: Chip(
                        key: const Key('companion_lan_scan_ready_chip'),
                        label: Text(_statusText),
                      ),
                    )
                  else
                    Text(
                      _statusText,
                      key: const Key('companion_lan_scan_status'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  const SizedBox(height: 12),
                  FilledButton(
                    key: const Key('companion_lan_send_scan_button'),
                    onPressed: _hasPending ? _send : null,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(56),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: const Text('Escanear'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}