import 'package:flutter_test/flutter_test.dart';
import 'package:scanner_companion/companion_qr_link.dart';

void main() {
  test('SC-117-01 lee host, puerto y código del enlace corto', () {
    final link = parseCompanionQrLink('https://10.165.87.116:8765/c/A7K9M2');
    expect(link, isNotNull);
    expect(link!.host, '10.165.87.116');
    expect(link.port, 8765);
    expect(link.pairingCode, 'A7K9M2');
    expect(link.tls, isTrue);
  });

  test('SC-117-02 rechaza un path que no es /c/{codigo}', () {
    expect(
      parseCompanionQrLink('https://10.165.87.116:8765/companion/'),
      isNull,
    );
    expect(parseCompanionQrLink('no-es-una-url'), isNull);
  });
}
