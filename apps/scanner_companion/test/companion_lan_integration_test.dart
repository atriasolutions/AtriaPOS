import 'package:adapters/companion_lan_server.dart';
import 'package:adapters/companion_lan_tls.dart';
import 'package:core/api/api.dart';
import 'package:core/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scanner_companion/companion_lan_client.dart';
import 'package:scanner_companion/companion_lan_gateway.dart';

void main() {
  test('SC-121-01 un scan llega al servidor LAN', () async {
    final service = CompanionService();
    final tls = CompanionLanTlsMaterial.forTest(ip: '127.0.0.1');
    final server = CompanionLanServer(
      companionService: service,
      host: '127.0.0.1',
      port: 0,
      securityContext: tls.securityContext,
      caPem: tls.caPem,
    );
    await server.start();
    try {
      const storeId = 't1';
      final offer = await service.createPairingOffer(
        storeId,
        CompanionMode.vender,
      );
      final code =
          (offer as ApiSuccess<CreateCompanionPairingOfferResponse>).data
              .pairingCode;
      final port = server.boundPort!;
      final client = CompanionLanClient(IoCompanionPosGateway.new);
      final session = await client.connectLink(
        'https://127.0.0.1:$port/c/$code',
      );
      final next = server.scans.first;
      session.sendScan('7801234567890');
      expect(
        await next.timeout(const Duration(seconds: 3)),
        '7801234567890',
      );
    } finally {
      await server.stop();
    }
  });
}
