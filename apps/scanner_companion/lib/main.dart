import 'package:core/scanner/scanner_ble_constants.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void main() => runApp(const ScannerCompanionApp());

class ScannerCompanionApp extends StatelessWidget {
  const ScannerCompanionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'POS Escáner',
      home: const ScanHomeScreen(),
    );
  }
}

class ScanHomeScreen extends StatefulWidget {
  const ScanHomeScreen({super.key});

  @override
  State<ScanHomeScreen> createState() => _ScanHomeScreenState();
}

class _ScanHomeScreenState extends State<ScanHomeScreen> {
  final _controller = MobileScannerController();
  String? _lastScan;
  String _status = 'Apunte la cámara al código';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    final barcode = capture.barcodes.firstOrNull;
    final value = barcode?.rawValue?.trim();
    if (value == null || value.isEmpty || value == _lastScan) return;
    setState(() {
      _lastScan = value;
      _status = 'Leído: $value (envío BLE pendiente de pareo)';
    });
    // TODO(slice-17): escritura GATT vía flutter_blue_plus al POS.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ScannerBleConstants.deviceNamePrefix),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: MobileScanner(
              controller: _controller,
              onDetect: _onDetect,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(_status, textAlign: TextAlign.center),
            ),
          ),
        ],
      ),
    );
  }
}