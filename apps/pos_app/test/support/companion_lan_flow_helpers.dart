import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:adapters/companion_lan_server.dart';
import 'package:core/api/api.dart';
import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:pos_app/config/store_config.dart';
import 'package:pos_app/di/pos_composition.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

typedef CompanionWsSession = ({WebSocketChannel channel, String token});

Future<void> seedSupervisorSession(PosComposition composition) async {
  await composition.ensureDemoUsers();
  await composition.authService.login(
    kDemoStoreId,
    const LoginRequest(
      username: 'usr_supervisor',
      pin: PosComposition.demoPin,
    ),
  );
}

Future<void> seedShiftOpen(PosComposition composition) async {
  await seedSupervisorSession(composition);
  await composition.shiftService.openShift(
    kDemoStoreId,
    const OpenShiftRequest(openingCashClp: 0),
  );
}

Future<CompanionLanServer> requireCompanionServer(PosComposition composition) async {
  final server = composition.companionLanServer;
  if (server == null) {
    throw StateError('Companion LAN no habilitado en esta composición');
  }
  await composition.ensureCompanionLanServerStarted();
  return server;
}

Future<CompanionWsSession> pairCompanionOverWs({
  required PosComposition composition,
  required CompanionMode mode,
}) async {
  final server = await requireCompanionServer(composition);
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
    'mode': mode.apiValue,
  }));
  final res = await req.close();
  if (res.statusCode != 200) {
    throw StateError('Pair falló: ${res.statusCode}');
  }
  final body = jsonDecode(await res.transform(utf8.decoder).join())
      as Map<String, dynamic>;
  final token = body['token'] as String;
  final wsUri = server.baseUri
      .replace(
        path: CompanionLanConstants.wsPath,
        queryParameters: {'token': token},
      )
      .toString()
      .replaceFirst('http', 'ws');
  final channel = WebSocketChannel.connect(Uri.parse(wsUri));
  await Future<void>.delayed(const Duration(milliseconds: 80));
  return (channel: channel, token: token);
}

void sendCompanionScan(WebSocketChannel channel, String code) {
  channel.sink.add(jsonEncode({'type': 'scan', 'code': code}));
}

Future<String> listenIngressOnce(
  PosComposition composition, {
  Duration timeout = const Duration(seconds: 3),
}) {
  return composition.scannerIngress.scans.first.timeout(timeout);
}

Future<ApiResult<SearchProductsResponse>> simulateVenderOnLanScan(
  PosComposition composition,
  CompanionMode mode,
  String barcode,
) async {
  final completer = Completer<ApiResult<SearchProductsResponse>>();
  final sub = composition.scannerIngress.scans.listen((code) async {
    if (completer.isCompleted) return;
    final result = await composition.productService.searchProducts(
      kDemoStoreId,
      code,
    );
    completer.complete(result);
  });
  final session = await pairCompanionOverWs(composition: composition, mode: mode);
  try {
    sendCompanionScan(session.channel, barcode);
    return await completer.future.timeout(const Duration(seconds: 3));
  } finally {
    await sub.cancel();
    await session.channel.sink.close();
  }
}

Future<ApiResult<ScanSessionResponse>> simulateRecordScanOnLanScan(
  PosComposition composition,
  CompanionMode mode,
  String sessionId,
  String barcode,
) async {
  final completer = Completer<ApiResult<ScanSessionResponse>>();
  final sub = composition.scannerIngress.scans.listen((code) async {
    if (completer.isCompleted) return;
    final result = await composition.scanSessionService.recordScan(
      kDemoStoreId,
      sessionId,
      RecordScanRequest(code: code),
    );
    completer.complete(result);
  });
  final session = await pairCompanionOverWs(composition: composition, mode: mode);
  try {
    sendCompanionScan(session.channel, barcode);
    return await completer.future.timeout(const Duration(seconds: 3));
  } finally {
    await sub.cancel();
    await session.channel.sink.close();
  }
}