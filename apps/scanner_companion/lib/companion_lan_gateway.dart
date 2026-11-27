import 'dart:convert';
import 'dart:io';

import 'package:web_socket_channel/io.dart';

import 'companion_lan_client.dart';

/// Cliente HTTP/WebSocket. Acepta el certificado solo si el host es [allowedHost].
class IoCompanionPosGateway implements CompanionPosGateway {
  IoCompanionPosGateway(this.allowedHost);

  final String allowedHost;

  HttpClient _open() {
    return HttpClient()
      ..badCertificateCallback = (cert, host, port) => host == allowedHost;
  }

  @override
  Future<Uri?> getShortLinkLocation(Uri shortUri) async {
    final client = _open();
    try {
      final request = await client.getUrl(shortUri);
      request.followRedirects = false;
      final response = await request.close();
      final location = response.headers.value(HttpHeaders.locationHeader);
      await response.drain<void>();
      if (response.statusCode != 301 && response.statusCode != 302) {
        return null;
      }
      if (location == null || location.isEmpty) return null;
      return shortUri.resolve(location);
    } finally {
      client.close(force: true);
    }
  }

  @override
  Future<Map<String, dynamic>> postPair(
    Uri pairUri,
    Map<String, Object?> body,
  ) async {
    final client = _open();
    try {
      final request = await client.postUrl(pairUri);
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(body));
      final response = await request.close();
      final text = await response.transform(utf8.decoder).join();
      if (response.statusCode != 200) {
        throw const CompanionLinkRejected();
      }
      final decoded = jsonDecode(text);
      if (decoded is! Map<String, dynamic>) {
        throw const CompanionLinkRejected();
      }
      return decoded;
    } finally {
      client.close(force: true);
    }
  }

  @override
  Future<CompanionScanSink> connectWs(Uri wsUri) async {
    final client = _open();
    final socket = await WebSocket.connect(
      wsUri.toString(),
      customClient: client,
    );
    final channel = IOWebSocketChannel(socket);
    return _ChannelScanSink(channel);
  }
}

class _ChannelScanSink implements CompanionScanSink {
  _ChannelScanSink(this._channel);

  final IOWebSocketChannel _channel;

  @override
  void add(String text) {
    _channel.sink.add(text);
  }

  @override
  Stream<String> get inbound =>
      _channel.stream.map((event) => event.toString());
}
