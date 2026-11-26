import 'package:flutter/material.dart';

import 'companion_armed_scan.dart';
import 'companion_camera_view.dart';
import 'companion_lan_client.dart';

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
  String _status = 'Apunte la cámara al código';

  DateTime _now() => widget.now?.call() ?? DateTime.now();

  void handleCode(String raw) {
    if (!_armed.onDetect(raw, _now())) return;
    setState(() => _status = 'Listo: ${_armed.pending}');
  }

  void _send() {
    final code = _armed.trigger();
    if (code == null) {
      setState(() => _status = 'Apunte la cámara al código');
      return;
    }
    widget.session.sendScan(code);
    setState(() => _status = 'Leído: $code');
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
            child: const Text('Cerrar conexión'),
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
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  _status,
                  key: const Key('companion_lan_scan_status'),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                FilledButton(
                  key: const Key('companion_lan_send_scan_button'),
                  onPressed: _send,
                  child: const Text('Escanear'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
