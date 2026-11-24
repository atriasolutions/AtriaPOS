import 'dart:async';
import 'dart:math';

import 'package:core/scanner/companion_pairing_match.dart';
import 'package:core/scanner/scan_payload_codec.dart';
import 'package:core/scanner/scanner_ble_constants.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' hide FlutterBluePlus;
import 'package:flutter_blue_plus_windows/flutter_blue_plus_windows.dart';

import 'scanner_connection_state.dart';
import 'scanner_ingress.dart';

/// POS Windows: escanea companion `POS-Barrio-{código}`, se suscribe a NOTIFY.
class BleCentralScannerIngress implements ScannerIngress {
  BleCentralScannerIngress({
    StreamScannerIngress? inner,
    this.enableRadio = true,
  }) : _inner = inner ?? StreamScannerIngress();

  /// Desactivar en widget tests para no usar el adaptador BLE real.
  final bool enableRadio;

  final StreamScannerIngress _inner;
  final _stateController =
      StreamController<ScannerConnectionState>.broadcast();

  String? _pairingCode;
  BluetoothDevice? _device;
  StreamSubscription<List<ScanResult>>? _scanSub;
  StreamSubscription<List<int>>? _notifySub;
  String? _lastPayload;
  DateTime? _lastPayloadAt;
  bool _pairingActive = false;
  String? _pairingErrorMessage;

  String? get pairingCode => _pairingCode;

  /// Mensaje cuando [ScannerConnectionState.error] (p. ej. scan BT en Windows).
  String? get pairingErrorMessage => _pairingErrorMessage;

  Stream<ScannerConnectionState> get connectionState => _stateController.stream;

  @override
  Stream<String> get scans => _inner.scans;

  void _emit(ScannerConnectionState s) {
    if (!_stateController.isClosed) _stateController.add(s);
  }

  String generatePairingCode() {
    final r = Random.secure();
    _pairingCode = (1000 + r.nextInt(9000)).toString();
    return _pairingCode!;
  }

  /// Inicia pareo: genera código si falta y busca dispositivo companion.
  Future<void> startPairing({String? pairingCode}) async {
    _pairingActive = true;
    _pairingErrorMessage = null;
    _pairingCode = pairingCode ?? _pairingCode ?? generatePairingCode();
    _emit(ScannerConnectionState.scanning);
    if (!enableRadio) return;
    await stop();
    try {
      final serviceGuid = Guid(ScannerBleConstants.serviceUuid);
      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 120),
        withServices: [serviceGuid],
      );
    } catch (_) {
      _pairingErrorMessage =
          'No se pudo iniciar Bluetooth en este equipo. Revise que el adaptador esté activo.';
      _emit(ScannerConnectionState.error);
      return;
    }

    final serviceGuid = Guid(ScannerBleConstants.serviceUuid);
    final expectedCode = _pairingCode!;
    _scanSub = FlutterBluePlus.scanResults.listen((results) async {
      for (final r in results) {
        final name = r.device.platformName.isNotEmpty
            ? r.device.platformName
            : r.advertisementData.advName;
        final serviceData = r.advertisementData.serviceData[serviceGuid];
        if (!companionPairingMatches(
          expectedCode,
          advName: name,
          serviceData: serviceData,
        )) {
          continue;
        }
        await FlutterBluePlus.stopScan();
        await _scanSub?.cancel();
        _scanSub = null;
        await _connect(r.device);
        return;
      }
    });
  }

  Future<void> _connect(BluetoothDevice device) async {
    if (!_pairingActive) return;
    _emit(ScannerConnectionState.connecting);
    _device = device;
    try {
      await device.connect(timeout: const Duration(seconds: 15));
      final services = await device.discoverServices();
      final serviceGuid = Guid(ScannerBleConstants.serviceUuid);
      final charGuid = Guid(ScannerBleConstants.scanCharacteristicUuid);
      for (final s in services) {
        if (s.uuid != serviceGuid) continue;
        for (final c in s.characteristics) {
          if (c.uuid != charGuid) continue;
          await c.setNotifyValue(true);
          _notifySub = c.onValueReceived.listen(_onNotify);
          _emit(ScannerConnectionState.connected);
          return;
        }
      }
      _pairingErrorMessage = 'No se encontró el servicio del escáner en el dispositivo.';
      _emit(ScannerConnectionState.error);
    } catch (_) {
      _pairingErrorMessage = 'No se pudo conectar al escáner.';
      _emit(ScannerConnectionState.error);
    }
  }

  void _onNotify(List<int> value) {
    final decoded = decodeScanPayload(value);
    if (decoded == null) return;
    final now = DateTime.now();
    if (_lastPayload == decoded &&
        _lastPayloadAt != null &&
        now.difference(_lastPayloadAt!) <
            ScannerBleConstants.debounceDelay) {
      return;
    }
    _lastPayload = decoded;
    _lastPayloadAt = now;
    _inner.push(decoded);
  }

  @override
  Future<void> start() async {
    if (_pairingCode != null && _device == null) {
      await startPairing(pairingCode: _pairingCode);
    }
  }

  @override
  Future<void> stop() async {
    _pairingActive = false;
    await _scanSub?.cancel();
    _scanSub = null;
    await _notifySub?.cancel();
    _notifySub = null;
    if (enableRadio) {
      try {
        await FlutterBluePlus.stopScan();
      } catch (_) {}
    }
    if (_device != null) {
      try {
        await _device!.disconnect();
      } catch (_) {}
      _device = null;
    }
    _emit(ScannerConnectionState.disconnected);
  }

  @override
  void dispose() {
    unawaited(stop());
    _stateController.close();
    _inner.dispose();
  }
}