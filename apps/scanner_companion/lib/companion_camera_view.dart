import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import 'companion_qr_link.dart';

const cameraPermissionMessage =
    'Se necesita la cámara para leer el QR del POS';

/// Pide el permiso de cámara. True solo si el usuario lo concede.
Future<bool> ensureCompanionCamera() async {
  final status = await Permission.camera.request();
  return status.isGranted;
}

/// Abre los ajustes de la app para habilitar la cámara.
Future<void> openCompanionCameraSettings() {
  return openAppSettings();
}

/// Texto del fallo del visor, en español.
String companionCameraErrorLabel(MobileScannerErrorCode code) {
  return switch (code) {
    MobileScannerErrorCode.permissionDenied => cameraPermissionMessage,
    MobileScannerErrorCode.unsupported =>
      'Este equipo no puede usar la cámara.',
    _ => 'No se pudo abrir la cámara (${code.name}).',
  };
}

class CompanionCameraErrorView extends StatelessWidget {
  const CompanionCameraErrorView({
    super.key,
    required this.error,
    required this.onRetry,
  });

  final MobileScannerException error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                companionCameraErrorLabel(error.errorCode),
                key: const Key('companion_camera_error'),
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton(
                key: const Key('companion_camera_retry_button'),
                onPressed: onRetry,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Visor que arranca recién cuando el permiso ya fue concedido.
class CompanionCameraView extends StatefulWidget {
  const CompanionCameraView({
    super.key,
    required this.onCode,
    this.onlyPairingLink = false,
  });

  final void Function(String code) onCode;
  final bool onlyPairingLink;

  @override
  State<CompanionCameraView> createState() => _CompanionCameraViewState();
}

class _CompanionCameraViewState extends State<CompanionCameraView> {
  late final MobileScannerController _controller = MobileScannerController(
    autoStart: false,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(_controller.start());
    });
  }

  @override
  void dispose() {
    unawaited(_controller.dispose());
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    final raw = capture.barcodes.firstOrNull?.rawValue;
    if (raw == null) return;
    if (widget.onlyPairingLink && parseCompanionQrLink(raw) == null) return;
    widget.onCode(raw);
  }

  Future<void> _retry() async {
    await _controller.stop();
    if (!mounted) return;
    await _controller.start();
  }

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      controller: _controller,
      onDetect: _onDetect,
      errorBuilder: (context, error, child) {
        return CompanionCameraErrorView(
          error: error,
          onRetry: () => unawaited(_retry()),
        );
      },
    );
  }
}
