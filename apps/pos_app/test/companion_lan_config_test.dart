import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app/config/companion_lan_config.dart';

void main() {
  test('SC-109-06 prioriza RNDIS sobre VMware', () {
    final rndis = CompanionLanConfig.companionLanScoreInterface(
      'Remote NDIS Compatible Device',
      '192.168.42.129',
    );
    final vmware = CompanionLanConfig.companionLanScoreInterface(
      'VMware Network Adapter VMnet8',
      '192.168.134.1',
    );
    expect(rndis, greaterThan(vmware));
  });
}