import 'dart:typed_data';

import 'package:core/scanner/scan_payload_codec.dart';
import 'package:core/scanner/scanner_ble_constants.dart';
import 'package:flutter_ble_peripheral/flutter_ble_peripheral.dart';

/// Companion Android: anuncia servicio GATT y notifica lecturas al POS.
class CompanionBlePeripheral {
  final _ble = FlutterBlePeripheral();
  bool _advertising = false;

  Future<void> start(String pairingCode) async {
    await _ble.requestPermission();
    final serviceUuid = ScannerBleConstants.serviceUuid;
    final charUuid = ScannerBleConstants.scanCharacteristicUuid;

    // Android: no meter UUID + nombre del teléfono en un solo paquete (ADVERTISE_FAILED_DATA_TOO_LARGE).
    await _ble.start(
      advertiseData: const AndroidAdvertiseData(
        serviceUuid: ScannerBleConstants.serviceUuid,
        includeDeviceName: false,
      ),
      gattServer: GattServerSettings(
        serviceUuid: serviceUuid,
        characteristics: [
          GattCharacteristic.notify(charUuid),
        ],
      ),
      androidSettings: AndroidAdvertiseSettings(
        advertiseSettings: const AdvertiseSettings(connectable: true),
        advertiseResponseData: AndroidAdvertiseData(
          serviceDataUuid: serviceUuid,
          serviceData:
              ScannerBleConstants.pairingAdvertiseServiceData(pairingCode),
        ),
      ),
    );
    _advertising = true;
  }

  Future<void> notifyScan(String raw) async {
    if (!_advertising) return;
    final bytes = encodeScanPayload(raw);
    if (bytes.isEmpty) return;
    try {
      await _ble.sendData(
        Uint8List.fromList(bytes),
        characteristicUuid: ScannerBleConstants.scanCharacteristicUuid,
      );
    } catch (_) {
      // Sin central suscrito aún.
    }
  }

  Future<void> stop() async {
    if (!_advertising) return;
    await _ble.stop();
    _advertising = false;
  }
}