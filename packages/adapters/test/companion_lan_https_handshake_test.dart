import 'dart:convert';
import 'dart:io';

import 'package:adapters/companion_lan_tls.dart';
import 'package:test/test.dart';

void main() {
  test('SC-109-04b handshake leaf emitido para IP', () async {
    final keys = CompanionLanTlsMaterial.issueSelfSignedServer(ipv4: '127.0.0.1');
    final ctx = SecurityContext();
    ctx.useCertificateChainBytes(utf8.encode(keys.certPem.trim()));
    ctx.usePrivateKeyBytes(utf8.encode(keys.keyPem.trim()));

    final server = await HttpServer.bindSecure(
      InternetAddress.loopbackIPv4,
      0,
      ctx,
    );
    server.listen((req) {
      req.response
        ..write('ok')
        ..close();
    });
    addTearDown(() => server.close(force: true));

    final client = HttpClient()
      ..badCertificateCallback = (_, __, ___) => true;
    addTearDown(client.close);

    final uri = Uri(
      scheme: 'https',
      host: InternetAddress.loopbackIPv4.address,
      port: server.port,
      path: '/',
    );
    final res = await client.getUrl(uri).then((r) => r.close());
    expect(res.statusCode, 200);
    await res.drain();
  });
}