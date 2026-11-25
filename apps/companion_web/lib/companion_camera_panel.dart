import 'dart:async';

import 'package:companion_web/companion_scan_dedup.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Visor opcional de cámara (DEC-061, SLICE-110). Si falla, sin caja vacía.
class CompanionCameraPanel extends StatefulWidget {
  const CompanionCameraPanel({
    super.key,
    required this.enabled,
    required this.onCode,
    this.startUnavailable = false,
  });

  final bool enabled;
  final Future<void> Function(String code) onCode;

  /// Solo tests: simula fallo de cámara sin instanciar hardware.
  final bool startUnavailable;

  @override
  State<CompanionCameraPanel> createState() => _CompanionCameraPanelState();
}

class _CompanionCameraPanelState extends State<CompanionCameraPanel> {
  late final MobileScannerController _controller;
  final CompanionScanDedup _dedup = CompanionScanDedup();
  late bool _unavailable;
  String? _sendError;

  @override
  void initState() {
    super.initState();
    _unavailable = widget.startUnavailable;
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
    );
  }

  @override
  void dispose() {
    unawaited(_controller.dispose());
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (!widget.enabled || _unavailable) return;
    final codes = capture.barcodes;
    if (codes.isEmpty) return;
    final code = codes.first.rawValue?.trim();
    if (code == null || code.isEmpty) return;
    if (!_dedup.shouldAccept(code, DateTime.now())) return;
    try {
      await widget.onCode(code);
    } catch (e) {
      if (!mounted) return;
      setState(() => _sendError = e.toString());
    }
  }

  void _onScannerError(MobileScannerException error) {
    if (!mounted) return;
    setState(() => _unavailable = true);
  }

  @override
  Widget build(BuildContext context) {
    if (_unavailable) {
      return const Padding(
        padding: EdgeInsets.only(bottom: 8),
        child: Text(
          'Cámara no disponible. Use el campo de código debajo.',
          key: Key('companion_camera_unavailable'),
          style: TextStyle(fontSize: 13),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            height: 220,
            child: MobileScanner(
              key: const Key('companion_camera_scanner'),
              controller: _controller,
              onDetect: _onDetect,
              errorBuilder: (context, error, child) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _onScannerError(error);
                });
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
        if (_sendError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              _sendError!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
      ],
    );
  }
}