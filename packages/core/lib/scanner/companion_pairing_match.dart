import 'scanner_ble_constants.dart';

/// SC-011-BLE-03: POS central matchea companion por nombre o service data (Android).
bool companionPairingMatches(
  String pairingCode, {
  String? advName,
  List<int>? serviceData,
}) {
  final targetName = ScannerBleConstants.deviceNameForPairing(pairingCode);
  final name = advName?.trim();
  final nameMatches = name != null &&
      name.isNotEmpty &&
      (name == targetName || name.contains(targetName));
  final codeMatches =
      ScannerBleConstants.pairingAdvertiseMatches(pairingCode, serviceData);
  return nameMatches || codeMatches;
}