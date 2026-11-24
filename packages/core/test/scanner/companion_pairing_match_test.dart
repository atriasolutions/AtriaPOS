import 'package:core/scanner/companion_pairing_match.dart';
import 'package:core/scanner/scanner_ble_constants.dart';
import 'package:test/test.dart';

void main() {
  test('SC-011-BLE-03 matchea por service data sin nombre Android', () {
    final data = ScannerBleConstants.pairingAdvertiseServiceData('4821');
    expect(
      companionPairingMatches('4821', advName: '', serviceData: data),
      isTrue,
    );
    expect(
      companionPairingMatches('9999', advName: '', serviceData: data),
      isFalse,
    );
  });

  test('SC-011-BLE-03 matchea por nombre Atria-POS-{código}', () {
    expect(
      companionPairingMatches('1234', advName: 'Atria-POS-1234'),
      isTrue,
    );
    expect(
      companionPairingMatches('1234', advName: 'other'),
      isFalse,
    );
  });
}