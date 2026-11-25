import 'dart:convert';
import 'dart:io';

import 'package:core/api/api.dart';
import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app/config/store_config.dart';
import 'package:pos_app/di/pos_composition.dart';
import 'package:pos_app/scanner/lan_scanner_ingress.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  setUpAll(() {
    PosComposition.lanCompanionTls = false;
    PosComposition.companionAdvertisedHost = '127.0.0.1';
  });

  test('SC-099-01 prepareCompanionQr inicia servidor', () async {
    final composition = PosComposition.memory();
    try {
      if (composition.companionLanServer == null) return;
      await composition.ensureDemoStore();
      final state = await composition.prepareCompanionQr(CompanionMode.vender);
      expect(state, isNotNull);
      expect(state!.serverRunning, isTrue);
      expect(state.pairingCode.length, CompanionLanConstants.pairingCodeLength);
      expect(state.launchUrl, contains('/c/${state.pairingCode}'));
      expect(state.launchUrl.contains('storeId'), isFalse);
    } finally {
      await composition.close();
    }
  }, skip: !Platform.isWindows ? 'Solo Windows (LAN default)' : false);

  test('SC-101-01 scan LAN llega al ingress', () async {
    final composition = PosComposition.memory();
    try {
      final server = composition.companionLanServer;
      if (server == null) return;
      expect(composition.scannerIngress, isA<LanScannerIngress>());
      await composition.ensureDemoStore();
      await composition.ensureCompanionLanServerStarted();

      final offer = await composition.companionService.createPairingOffer(
        kDemoStoreId,
        CompanionMode.vender,
      );
      final code =
          (offer as ApiSuccess<CreateCompanionPairingOfferResponse>).data
              .pairingCode;

      final pairUri = server.baseUri.replace(
        path: '/v0/stores/$kDemoStoreId/companion/pair',
      );
      final client = HttpClient();
      final req = await client.postUrl(pairUri);
      req.headers.contentType = ContentType.json;
      req.write(jsonEncode({'pairingCode': code, 'mode': 'VENDER'}));
      final res = await req.close();
      expect(res.statusCode, 200);
      final body = jsonDecode(await res.transform(utf8.decoder).join())
          as Map<String, dynamic>;
      final token = body['token'] as String;

      final next = composition.scannerIngress.scans.first;
      final wsUri = server.baseUri
          .replace(
            path: CompanionLanConstants.wsPath,
            queryParameters: {'token': token},
          )
          .toString()
          .replaceFirst('http', 'ws');
      final channel = WebSocketChannel.connect(Uri.parse(wsUri));
      channel.sink.add(jsonEncode({'type': 'scan', 'code': '7801234567890'}));
      final scanned = await next.timeout(const Duration(seconds: 3));
      expect(scanned, '7801234567890');
      await channel.sink.close();
    } finally {
      await composition.close();
    }
  }, skip: !Platform.isWindows ? 'Solo Windows (LAN default)' : false);

  test('SC-102-01 receiptScan entrega código al ingress', () async {
    await _expectModeScanOnIngress(CompanionMode.receiptScan, 'RECEIPT_SCAN');
  }, skip: !Platform.isWindows ? 'Solo Windows (LAN default)' : false);

  test('SC-103-01 countScan entrega código al ingress', () async {
    await _expectModeScanOnIngress(CompanionMode.countScan, 'COUNT_SCAN');
  }, skip: !Platform.isWindows ? 'Solo Windows (LAN default)' : false);
}

Future<void> _expectModeScanOnIngress(
  CompanionMode mode,
  String apiMode,
) async {
  final composition = PosComposition.memory();
  try {
    final server = composition.companionLanServer;
    if (server == null) return;
    await composition.ensureDemoStore();
    await composition.ensureCompanionLanServerStarted();
    final offer = await composition.createCompanionOffer(
      CreateCompanionPairingOfferInput(storeId: kDemoStoreId, mode: mode),
    );
    final pairUri = server.baseUri.replace(
      path: '/v0/stores/$kDemoStoreId/companion/pair',
    );
    final client = HttpClient();
    final req = await client.postUrl(pairUri);
    req.headers.contentType = ContentType.json;
    req.write(jsonEncode({
      'pairingCode': offer.pairingCode,
      'mode': apiMode,
    }));
    final res = await req.close();
    expect(res.statusCode, 200);
    final body = jsonDecode(await res.transform(utf8.decoder).join())
        as Map<String, dynamic>;
    final token = body['token'] as String;
    final next = composition.scannerIngress.scans.first;
    final wsUri = server.baseUri
        .replace(
          path: CompanionLanConstants.wsPath,
          queryParameters: {'token': token},
        )
        .toString()
        .replaceFirst('http', 'ws');
    final channel = WebSocketChannel.connect(Uri.parse(wsUri));
    channel.sink.add(jsonEncode({'type': 'scan', 'code': 'qty-test-code'}));
    expect(await next.timeout(const Duration(seconds: 3)), 'qty-test-code');
    await channel.sink.close();
  } finally {
    await composition.close();
  }
}
