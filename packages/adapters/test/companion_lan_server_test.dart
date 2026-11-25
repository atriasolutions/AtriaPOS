import 'dart:convert';
import 'dart:io';

import 'package:adapters/companion_lan_live_registry.dart';
import 'package:adapters/companion_lan_server.dart';
import 'package:adapters/companion_lan_tls.dart';
import 'package:core/api/api.dart';
import 'package:core/domain/domain.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:test/test.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

HttpClient trustedHttpClient(String trustPem) {
  final ctx = SecurityContext();
  ctx.setTrustedCertificatesBytes(utf8.encode(trustPem));
  final client = HttpClient(context: ctx);
  client.badCertificateCallback = (_, __, ___) => true;
  return client;
}

void main() {
  late CompanionLanLiveRegistry liveRegistry;
  late CompanionService service;

  setUp(() {
    liveRegistry = CompanionLanLiveRegistry();
    service = CompanionService(liveSessions: liveRegistry);
  });

  group('HTTP', () {
    late CompanionLanServer server;

    setUp(() async {
      server = CompanionLanServer(
        companionService: service,
        liveRegistry: liveRegistry,
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

    test('SC-111-03 WS registrado marca celular live', () async {
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
      final pairBody = jsonDecode(
        await pairRes.transform(utf8.decoder).join(),
      ) as Map<String, dynamic>;
      final token = pairBody['token'] as String;

      expect(liveRegistry.isLive(token), isFalse);
      expect((await service.getLanStatus(storeId)).phase, CompanionLanPhase.sessionOnly);

      final wsUri = server.baseUri
          .replace(
            path: CompanionLanConstants.wsPath,
            queryParameters: {'token': token},
          )
          .toString()
          .replaceFirst('http', 'ws');
      final channel = WebSocketChannel.connect(Uri.parse(wsUri));
      await Future<void>.delayed(const Duration(milliseconds: 100));
      expect(liveRegistry.isLive(token), isTrue);
      expect((await service.getLanStatus(storeId)).phase, CompanionLanPhase.live);
      await channel.sink.close();
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(liveRegistry.isLive(token), isFalse);
    });

    test('SC-111-05 token inválido no deja socket live', () async {
      final wsUri = server.baseUri
          .replace(
            path: CompanionLanConstants.wsPath,
            queryParameters: {'token': 'ctok_invalid'},
          )
          .toString()
          .replaceFirst('http', 'ws');
      final channel = WebSocketChannel.connect(Uri.parse(wsUri));
      await Future<void>.delayed(const Duration(milliseconds: 100));
      expect(liveRegistry.isLive('ctok_invalid'), isFalse);
      await channel.sink.close();
    });

    test('DX-2 carpeta con index.html responde ese HTML', () async {
      final dir = await Directory.systemTemp.createTemp('companion_dx2_ok_');
      addTearDown(() => dir.delete(recursive: true));
      const html = '<!DOCTYPE html><html><body>PWA-DX2</body></html>';
      await File(
        '${dir.path}${Platform.pathSeparator}index.html',
      ).writeAsString(html);
      final rooted = CompanionLanServer(
        companionService: service,
        liveRegistry: liveRegistry,
        host: InternetAddress.loopbackIPv4.address,
        port: 0,
        staticRoot: dir,
      );
      await rooted.start();
      addTearDown(rooted.stop);
      final res = await HttpClient()
          .getUrl(rooted.baseUri.replace(path: '/companion/'))
          .then((r) => r.close());
      expect(res.statusCode, 200);
      expect(await res.transform(utf8.decoder).join(), html);
    });

    test('DX-2 carpeta sin index.html responde No encontrado', () async {
      final dir = await Directory.systemTemp.createTemp('companion_dx2_empty_');
      addTearDown(() => dir.delete(recursive: true));
      final rooted = CompanionLanServer(
        companionService: service,
        liveRegistry: liveRegistry,
        host: InternetAddress.loopbackIPv4.address,
        port: 0,
        staticRoot: dir,
      );
      await rooted.start();
      addTearDown(rooted.stop);
      final res = await HttpClient()
          .getUrl(rooted.baseUri.replace(path: '/companion/'))
          .then((r) => r.close());
      expect(res.statusCode, 404);
      expect(await res.transform(utf8.decoder).join(), 'No encontrado');
    });

    test('DX-2 sin staticRoot responde el placeholder', () async {
      final res = await HttpClient()
          .getUrl(server.baseUri.replace(path: '/companion/'))
          .then((r) => r.close());
      expect(res.statusCode, 200);
      expect(
        await res.transform(utf8.decoder).join(),
        contains('Companion Atria POS'),
      );
    });
  });

  group('HTTPS (SLICE-109)', () {
    late CompanionLanServer server;
    late CompanionLanTlsMaterial tls;

    setUp(() async {
      tls = CompanionLanTlsMaterial.forTest(ip: '127.0.0.1');
      server = CompanionLanServer(
        companionService: service,
        liveRegistry: liveRegistry,
        host: InternetAddress.loopbackIPv4.address,
        port: 0,
        securityContext: tls.securityContext,
        caPem: tls.caPem,
      );
      await server.start();
      expect(server.usesTls, isTrue);
      expect(server.baseUri.scheme, 'https');
    });

    tearDown(() async {
      await server.stop();
    });

    test('SC-109-03 sirve CA en /companion/atria-ca.pem', () async {
      final client = trustedHttpClient(tls.serverCertPem);
      addTearDown(client.close);
      final uri = server.baseUri.replace(path: CompanionLanServer.caDownloadPath);
      final res = await client.getUrl(uri).then((r) => r.close());
      expect(res.statusCode, 200);
      final body = await res.transform(utf8.decoder).join();
      expect(body, contains('BEGIN CERTIFICATE'));
    });

    test('SC-109-04 health por HTTPS', () async {
      final client = trustedHttpClient(tls.serverCertPem);
      addTearDown(client.close);
      final uri = server.baseUri.replace(path: '/health');
      final res = await client.getUrl(uri).then((r) => r.close());
      expect(res.statusCode, 200);
    });

    test('SC-109-05 redirect /c bajo HTTPS', () async {
      const storeId = 't1';
      final offer = await service.createPairingOffer(
        storeId,
        CompanionMode.vender,
      );
      final code =
          (offer as ApiSuccess<CreateCompanionPairingOfferResponse>).data
              .pairingCode;
      final ioClient = IOClient(trustedHttpClient(tls.serverCertPem));
      addTearDown(ioClient.close);
      final uri = server.baseUri.replace(
        path: '${CompanionLanConstants.shortLinkPathPrefix}/$code',
      );
      final request = http.Request('GET', uri)..followRedirects = false;
      final res = await ioClient.send(request).then(http.Response.fromStream);
      expect(res.statusCode, 302);
      expect(res.headers['location'], contains('/companion/'));
    });
  });
}