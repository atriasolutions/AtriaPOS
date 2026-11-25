import 'dart:convert';
import 'dart:io';

import 'package:adapters/companion_lan_server.dart';
import 'package:core/api/api.dart';
import 'package:core/domain/domain.dart';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  late CompanionService service;
  late CompanionLanServer server;

  setUp(() async {
    service = CompanionService();
    server = CompanionLanServer(
      companionService: service,
      host: InternetAddress.loopbackIPv4.address,
      port: 0,
    );
    await server.start();
  });

  tearDown(() async {
    await server.stop();
  });

  test('SC-097-01 health responde ok', () async {
    final uri = server.baseUri.replace(path: '/health');
    final response = await HttpClient()
        .getUrl(uri)
        .then((r) => r.close());
    expect(response.statusCode, 200);
    final body = await response.transform(utf8.decoder).join();
    expect(jsonDecode(body), containsPair('ok', true));
  });

  test('SC-097-02 estáticos companion', () async {
    final uri = server.baseUri.replace(path: '/companion/');
    final response = await HttpClient()
        .getUrl(uri)
        .then((r) => r.close());
    expect(response.statusCode, 200);
  });

  test('SC-107-03 GET /c/{code} redirige a PWA', () async {
    const storeId = 't1';
    final offer = await service.createPairingOffer(
      storeId,
      CompanionMode.vender,
    );
    final code =
        (offer as ApiSuccess<CreateCompanionPairingOfferResponse>).data
            .pairingCode;
    final uri = server.baseUri.replace(
      path: '${CompanionLanConstants.shortLinkPathPrefix}/$code',
    );
    final request = http.Request('GET', uri)..followRedirects = false;
    final streamed = await http.Client().send(request);
    final res = await http.Response.fromStream(streamed);
    expect(res.statusCode, 302);
    final location = res.headers['location'];
    expect(location, isNotNull);
    expect(location, contains('/companion/'));
    expect(location, contains('storeId=$storeId'));
    expect(location, contains('mode=VENDER'));
    expect(location, contains('pairingCode=$code'));
  });

  test('SC-107-04 GET /c/{code} inválido 404', () async {
    final uri = server.baseUri.replace(
      path: '${CompanionLanConstants.shortLinkPathPrefix}/ZZZZZZ',
    );
    final res = await HttpClient().getUrl(uri).then((r) => r.close());
    expect(res.statusCode, 404);
  });

  test('SC-098-01 pair y scan por WebSocket', () async {
    const storeId = 't1';
    final offer = await service.createPairingOffer(
      storeId,
      CompanionMode.vender,
    );
    final code =
        (offer as ApiSuccess<CreateCompanionPairingOfferResponse>).data
            .pairingCode;

    final pairUri = server.baseUri.replace(
      path: '/v0/stores/$storeId/companion/pair',
    );
    final client = HttpClient();
    final pairReq = await client.postUrl(pairUri);
    pairReq.headers.contentType = ContentType.json;
    pairReq.write(jsonEncode({'pairingCode': code, 'mode': 'VENDER'}));
    final pairRes = await pairReq.close();
    expect(pairRes.statusCode, 200);
    final pairBody = jsonDecode(
      await pairRes.transform(utf8.decoder).join(),
    ) as Map<String, dynamic>;
    final token = pairBody['token'] as String;

    final scanFuture = server.scans.first;
    final wsUri = server.baseUri.replace(
      path: CompanionLanConstants.wsPath,
      queryParameters: {'token': token},
    );
    final wsUriString = wsUri.toString().replaceFirst('http', 'ws');
    final channel = WebSocketChannel.connect(Uri.parse(wsUriString));
    channel.sink.add(jsonEncode({'type': 'scan', 'code': '7801234567890'}));
    final scanned = await scanFuture.timeout(const Duration(seconds: 3));
    expect(scanned, '7801234567890');
    await channel.sink.close();
  });
}