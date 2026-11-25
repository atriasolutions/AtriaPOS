import 'package:flutter/material.dart';

import 'companion_camera_view.dart';
import 'companion_lan_client.dart';
import 'companion_scan_dedup.dart';

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
  final _dedup = CompanionScanDedup();
  String _status = 'Apunte la cámara al código';

  DateTime _now() => widget.now?.call() ?? DateTime.now();

  void handleCode(String raw) {
    final code = raw.trim();
    if (code.isEmpty) return;
    if (!_dedup.shouldAccept(code, _now())) return;
    widget.session.sendScan(code);
    setState(() => _status = 'Leído: $code');
  }

  @override
  Widget build(BuildContext context) {
    final camera = widget.camera;
    return Scaffold(
      appBar: AppBar(title: const Text('Escanear')),
      body: Column(
        children: [
          Expanded(
            child: camera != null
                ? camera(handleCode)
                : CompanionCameraView(onCode: handleCode),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              _status,
              key: const Key('companion_lan_scan_status'),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
