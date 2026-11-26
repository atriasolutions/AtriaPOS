import 'package:core/scanner/scanner_ble_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'ble_peripheral.dart';
import 'companion_lan_client.dart';
import 'companion_lan_gateway.dart';
import 'lan_connect_screen.dart';

void main() => runApp(const ScannerCompanionApp());

class ScannerCompanionApp extends StatelessWidget {
  const ScannerCompanionApp({super.key, this.client});

  final CompanionLanClient? client;

  @override
  Widget build(BuildContext context) {
    final lan = client ?? CompanionLanClient(IoCompanionPosGateway.new);
    return MaterialApp(
      title: 'Atria Companion',
      home: LanConnectScreen(client: lan),
    );
  }
}

// BLE legacy — no es la puerta LAN (ver runbooks/companion-android-apk.md).
class PairingScreen extends StatefulWidget {
  const PairingScreen({super.key});

  @override
  State<PairingScreen> createState() => _PairingScreenState();
}

class _PairingScreenState extends State<PairingScreen> {
  final _codeController = TextEditingController();
  final _peripheral = CompanionBlePeripheral();
  String? _error;

  Future<void> _connect() async {
    final code = _codeController.text.trim();
    if (code.length != 4 || int.tryParse(code) == null) {
      setState(() => _error = 'Ingrese el código de 4 dígitos del POS');
      return;
    }
    setState(() => _error = null);
    try {
      await _peripheral.start(code);
      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ScanHomeScreen(
            peripheral: _peripheral,
            pairingCode: code,
          ),
        ),
      );
    } on PlatformException catch (e) {
      setState(() => _error = e.message ?? 'No se pudo iniciar Bluetooth');
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _peripheral.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pareo escáner')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'En el POS (Vender), pulse Conectar escáner y copie el código.',
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key('companion_pairing_code_field'),
              controller: _codeController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              decoration: const InputDecoration(
                labelText: 'Código de pareo',
                border: OutlineInputBorder(),
                counterText: '',
              ),
            ),
            if (_error != null)
              Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            const SizedBox(height: 16),
            FilledButton(
              key: const Key('companion_start_button'),
              onPressed: _connect,
              child: const Text('Anunciar y escanear'),
            ),
          ],
        ),
      ),
    );
  }
}

class ScanHomeScreen extends StatefulWidget {
  const ScanHomeScreen({
    super.key,
    required this.peripheral,
    required this.pairingCode,
  });

  final CompanionBlePeripheral peripheral;
  final String pairingCode;

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

  void _onDetect(BarcodeCapture capture) async {
    final barcode = capture.barcodes.firstOrNull;
    final value = barcode?.rawValue?.trim();
    if (value == null || value.isEmpty || value == _lastScan) return;
    _lastScan = value;
    setState(() => _status = 'Leído: $value');
    await widget.peripheral.notifyScan(value);
  }

  @override
  Widget build(BuildContext context) {
    final name = ScannerBleConstants.deviceNameForPairing(widget.pairingCode);
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
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