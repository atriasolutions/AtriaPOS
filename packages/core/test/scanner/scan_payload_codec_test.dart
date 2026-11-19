import 'package:core/scanner/scan_payload_codec.dart';
import 'package:core/scanner/scanner_ble_constants.dart';
import 'package:test/test.dart';

void main() {
  test('SC-011-BLE-02 decode trim y UTF-8', () {
    expect(decodeScanPayload('  hola  '), 'hola');
    final bytes = encodeScanPayload('pan');
    expect(decodeScanPayload(bytes), 'pan');
  });

  test('SC-011-BLE-02 rechaza payload vacío o muy largo', () {
    expect(decodeScanPayload(''), isNull);
    expect(
      decodeScanPayload('x' * (ScannerBleConstants.maxPayloadBytes + 1)),
      isNull,
    );
  });
}