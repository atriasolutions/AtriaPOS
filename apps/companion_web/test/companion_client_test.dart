import 'package:companion_web/companion_client.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  test('SC-100-01 parsea parámetros QR', () {
    final uri = Uri.parse(
      'http://192.168.0.10:8765/companion/?storeId=t1&mode=RECEIPT_SCAN&pairingCode=ABC123',
    );
    final params = CompanionLaunchParams.fromUri(uri);
    expect(params.storeId, 't1');
    expect(params.mode, CompanionMode.receiptScan);
    expect(params.pairingCode, 'ABC123');
    expect(params.posBase.host, '192.168.0.10');
  });
}