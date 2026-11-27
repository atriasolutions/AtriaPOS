import 'dart:async';
import 'dart:convert';

import 'package:core/application/application.dart';

import 'companion_qr_link.dart';

/// Destino de un texto JSON hacia el WebSocket del POS.
abstract class CompanionScanSink {
  void add(String text);

  /// Mensajes entrantes del POS (confirmaciones de escaneo, heartbeat, etc.).
  Stream<String> get inbound => const Stream<String>.empty();
}

/// Acceso al POS. El cliente de prueba sustituye esta puerta.
abstract class CompanionPosGateway {
  Future<Uri?> getShortLinkLocation(Uri shortUri);

  Future<Map<String, dynamic>> postPair(
    Uri pairUri,
    Map<String, Object?> body,
  );

  Future<CompanionScanSink> connectWs(Uri wsUri);
}

class CompanionLanSession {
  CompanionLanSession({
    required this.sink,
    required this.modeApi,
    required this.token,
    required this.storeId,
  }) {
    _inboundSub = sink.inbound.listen(_onInbound);
  }

  final CompanionScanSink sink;
  final String modeApi;
  final String token;
  final String storeId;

  /// Llamado cuando el POS confirma un escaneo (`productName` puede ser null).
  void Function(String code, String? productName)? onScanAcknowledged;

  StreamSubscription<String>? _inboundSub;

  void sendScan(String code) {
    sink.add(jsonEncode({'type': 'scan', 'code': code}));
  }

  void _onInbound(String raw) {
    final message = CompanionWsMessage.decode(raw);
    if (message == null) return;
    if (!CompanionWsMessage.isScanAccepted(message)) return;
    final name = CompanionWsMessage.scanAcceptedProductName(message);
    final ackCode =
        CompanionWsMessage.scanAcceptedCode(message) ?? '';
    onScanAcknowledged?.call(ackCode, name);
  }

  void dispose() {
    unawaited(_inboundSub?.cancel());
    _inboundSub = null;
  }
}

class CompanionLinkRejected implements Exception {
  const CompanionLinkRejected();
}

/// Empareja con el enlace corto y envía lecturas. Sin widgets.
class CompanionLanClient {
  CompanionLanClient(this._gatewayForHost);

  final CompanionPosGateway Function(String host) _gatewayForHost;

  Future<CompanionLanSession> connectLink(String raw) async {
    final link = parseCompanionQrLink(raw);
    if (link == null) {
      throw const CompanionLinkRejected();
    }
    final gateway = _gatewayForHost(link.host);
    final location = await gateway.getShortLinkLocation(link.shortUri);
    if (location == null) {
      throw const CompanionLinkRejected();
    }
    final query = location.queryParameters;
    final storeId = query['storeId'];
    final mode = query['mode'];
    final code = query['pairingCode'];
    if (storeId == null || mode == null || code == null) {
      throw const CompanionLinkRejected();
    }
    final pairUri = link.base.replace(
      path: '/v0/stores/$storeId/companion/pair',
    );
    final paired = await gateway.postPair(pairUri, {
      'pairingCode': code,
      'mode': mode,
    });
    final token = paired['token'];
    final wsPath = paired['wsPath'];
    if (token is! String || wsPath is! String) {
      throw const CompanionLinkRejected();
    }
    final wsUri = link.base.replace(
      scheme: link.tls ? 'wss' : 'ws',
      path: wsPath,
      queryParameters: {'token': token},
    );
    final sink = await gateway.connectWs(wsUri);
    return CompanionLanSession(
      sink: sink,
      modeApi: mode,
      token: token,
      storeId: storeId,
    );
  }
}

/// Etiqueta de caja para el modo que vino en el QR.
String companionLanModeLabel(String modeApi) {
  return switch (modeApi) {
    'VENDER' => 'Vender',
    'RECEIPT_SCAN' => 'Ingreso mercadería',
    'COUNT_SCAN' => 'Conteo inventario',
    _ => modeApi,
  };
}
