import 'dart:convert';

import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

class CompanionLaunchParams {
  const CompanionLaunchParams({
    required this.storeId,
    required this.mode,
    required this.pairingCode,
    required this.posBase,
  });

  factory CompanionLaunchParams.fromUri(Uri uri) {
    final q = uri.queryParameters;
    final storeId = q['storeId'];
    final modeRaw = q['mode'];
    final pairingCode = q['pairingCode'];
    if (storeId == null || modeRaw == null || pairingCode == null) {
      throw ArgumentError('Faltan parámetros del QR');
    }
    final mode = CompanionMode.fromApi(modeRaw);
    final base = uri.replace(path: '', query: '', fragment: '');
    return CompanionLaunchParams(
      storeId: storeId,
      mode: mode,
      pairingCode: pairingCode,
      posBase: base,
    );
  }

  final String storeId;
  final CompanionMode mode;
  final String pairingCode;
  final Uri posBase;
}

class CompanionClient {
  CompanionClient(this.httpClient);

  final http.Client httpClient;
  String? token;
  WebSocketChannel? _channel;

  Future<void> pair(CompanionLaunchParams params) async {
    final uri = params.posBase.replace(
      path: '/v0/stores/${params.storeId}/companion/pair',
    );
    final response = await httpClient.post(
      uri,
      headers: {'content-type': 'application/json'},
      body: jsonEncode({
        'pairingCode': params.pairingCode,
        'mode': params.mode.apiValue,
      }),
    );
    if (response.statusCode != 200) {
      throw StateError('Emparejamiento falló (${response.statusCode})');
    }
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    token = body['token'] as String;
    final wsPath = body['wsPath'] as String;
    final wsUri = params.posBase
        .replace(
          scheme: params.posBase.scheme == 'https' ? 'wss' : 'ws',
          path: wsPath,
          queryParameters: {'token': token},
        );
    _channel = WebSocketChannel.connect(wsUri);
  }

  Future<void> sendScan(String code) async {
    final channel = _channel;
    if (channel == null) {
      throw StateError('Sin WebSocket activo');
    }
    channel.sink.add(jsonEncode({'type': 'scan', 'code': code}));
  }

  void dispose() {
    _channel?.sink.close();
    httpClient.close();
  }
}