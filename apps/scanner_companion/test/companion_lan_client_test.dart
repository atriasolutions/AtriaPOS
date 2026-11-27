import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:scanner_companion/companion_lan_client.dart';

class _MemorySink implements CompanionScanSink {
  final messages = <String>[];

  @override
  void add(String text) => messages.add(text);

  @override
  Stream<String> get inbound => const Stream<String>.empty();
}

class _FakeGateway implements CompanionPosGateway {
  _FakeGateway(this.location);

  final Uri? location;
  int wsOpens = 0;
  final sink = _MemorySink();

  @override
  Future<Uri?> getShortLinkLocation(Uri shortUri) async => location;

  @override
  Future<Map<String, dynamic>> postPair(
    Uri pairUri,
    Map<String, Object?> body,
  ) async {
    return {
      'token': 'tok-1',
      'wsPath': '/v0/ws/companion',
    };
  }

  @override
  Future<CompanionScanSink> connectWs(Uri wsUri) async {
    wsOpens += 1;
    return sink;
  }
}

void main() {
  const raw = 'https://10.165.87.116:8765/c/A7K9M2';

  test('SC-118-01 pair abre el WebSocket', () async {
    final gateway = _FakeGateway(
      Uri.parse(
        'https://10.165.87.116:8765/companion/?storeId=tienda&mode=VENDER&pairingCode=A7K9M2',
      ),
    );
    final client = CompanionLanClient((_) => gateway);
    final session = await client.connectLink(raw);
    expect(session.token, 'tok-1');
    expect(session.modeApi, 'VENDER');
    expect(gateway.wsOpens, 1);
  });

  test('SC-118-02 enlace inválido no abre el WebSocket', () async {
    final gateway = _FakeGateway(null);
    final client = CompanionLanClient((_) => gateway);
    expect(
      () => client.connectLink(raw),
      throwsA(isA<CompanionLinkRejected>()),
    );
    expect(gateway.wsOpens, 0);
  });

  test('SC-118-03 sendScan envía type scan', () async {
    final gateway = _FakeGateway(
      Uri.parse(
        'https://10.165.87.116:8765/companion/?storeId=tienda&mode=VENDER&pairingCode=A7K9M2',
      ),
    );
    final client = CompanionLanClient((_) => gateway);
    final session = await client.connectLink(raw);
    session.sendScan('7801234567890');
    expect(
      jsonDecode(gateway.sink.messages.single),
      {'type': 'scan', 'code': '7801234567890'},
    );
  });
}
