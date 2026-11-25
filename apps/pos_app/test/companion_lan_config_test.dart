import 'dart:io';

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

  test('SC-113-01 entorno con index.html usa esa carpeta', () async {
    final root = await Directory.systemTemp.createTemp('dx3_ok_');
    addTearDown(() => root.delete(recursive: true));
    await File(
      '${root.path}${Platform.pathSeparator}index.html',
    ).writeAsString('ok');

    final selected = CompanionLanConfig.selectCompanionWebRoot(
      environmentRoot: root.path,
      candidates: const [],
    );

    expect(selected?.path, root.path);
  });

  test('SC-113-02 entorno sin index.html cae a candidato válido', () async {
    final root = await Directory.systemTemp.createTemp('dx3_empty_');
    final candidate = await Directory.systemTemp.createTemp('dx3_cand_');
    addTearDown(() => root.delete(recursive: true));
    addTearDown(() => candidate.delete(recursive: true));
    await File(
      '${candidate.path}${Platform.pathSeparator}index.html',
    ).writeAsString('ok');

    final selected = CompanionLanConfig.selectCompanionWebRoot(
      environmentRoot: root.path,
      candidates: [candidate.path],
    );

    expect(selected?.path, candidate.path);
  });

  test('SC-113-03 sin build válido devuelve null', () async {
    final root = await Directory.systemTemp.createTemp('dx3_empty_');
    addTearDown(() => root.delete(recursive: true));

    final selected = CompanionLanConfig.selectCompanionWebRoot(
      environmentRoot: root.path,
      candidates: const [],
    );

    expect(selected, isNull);
  });

  test('SC-113-01 entorno vacío usa el candidato con index.html', () async {
    final candidate = await Directory.systemTemp.createTemp('dx3_only_');
    addTearDown(() => candidate.delete(recursive: true));
    await File(
      '${candidate.path}${Platform.pathSeparator}index.html',
    ).writeAsString('ok');

    final selected = CompanionLanConfig.selectCompanionWebRoot(
      environmentRoot: '   ',
      candidates: [candidate.path],
    );

    expect(selected?.path, candidate.path);
  });

  test('SC-114-01 override de host en tests sync', () {
    CompanionLanConfig.advertisedHostOverrideForTests = '192.168.42.99';
    addTearDown(() => CompanionLanConfig.advertisedHostOverrideForTests = null);
    expect(CompanionLanConfig.resolveAdvertisedHostSync(), '192.168.42.99');
  });

  test('SC-114-02 RNDIS gana sobre VMware en pickAdvertisedHostIpv4', () {
    final picked = CompanionLanConfig.pickAdvertisedHostIpv4(
      hostOverride: '',
      addresses: [
        (
          interfaceName: 'VMware Network Adapter VMnet8',
          ipv4: '192.168.134.1',
        ),
        (
          interfaceName: 'Remote NDIS Compatible Device',
          ipv4: '192.168.42.129',
        ),
      ],
    );
    expect(picked, '192.168.42.129');
  });
}