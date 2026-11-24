import 'dart:convert';

/// GATT BLE para escáner companion → POS (DEC slice-17).
class ScannerBleConstants {
  ScannerBleConstants._();

  static const serviceUuid = '6f9a2c10-8a7b-4e5d-9c3f-111213141516';
  static const scanCharacteristicUuid = '6f9a2c10-8a7b-4e5d-9c3f-111213141517';
  static const maxPayloadBytes = 512;
  static const debounceDelay = Duration(milliseconds: 300);
  static const deviceNamePrefix = 'POS-Barrio';

  static String deviceNameForPairing(String pairingCode) =>
      '$deviceNamePrefix-$pairingCode';

  /// Service data en scan response (Android: paquete adv ≤ 31 bytes).
  static List<int> pairingAdvertiseServiceData(String pairingCode) =>
      utf8.encode(pairingCode);

  static bool pairingAdvertiseMatches(String pairingCode, List<int>? data) {
    if (data == null || data.isEmpty) return false;
    return utf8.decode(data, allowMalformed: true) == pairingCode;
  }
}