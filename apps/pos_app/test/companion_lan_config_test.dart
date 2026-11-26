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

  test('SC-126-01 pick distinto si cambia la tabla de interfaces', () {
    final first = CompanionLanConfig.pickAdvertisedHostIpv4(
      hostOverride: '',
      addresses: [
        (interfaceName: 'Ethernet 2', ipv4: '10.165.87.116'),
      ],
    );
    final second = CompanionLanConfig.pickAdvertisedHostIpv4(
      hostOverride: '',
      addresses: [
        (interfaceName: 'Ethernet 5', ipv4: '10.165.87.218'),
      ],
    );
    expect(first, '10.165.87.116');
    expect(second, '10.165.87.218');
  });

  test('SC-127-02 endpoint devuelve interfaz ganadora', () {
    final endpoint = CompanionLanConfig.pickAdvertisedEndpointIpv4(
      hostOverride: '',
      addresses: [
        (
          interfaceName: 'Remote NDIS Compatible Device',
          ipv4: '192.168.42.129',
        ),
        (interfaceName: 'Ethernet 5', ipv4: '10.165.87.218'),
      ],
    );
    expect(endpoint.host, '192.168.42.129');
    expect(endpoint.interfaceName, contains('NDIS'));
  });

  test('SC-128-01 Ethernet 10.x gana sobre VMware en la misma red', () {
    final vmware = CompanionLanConfig.companionLanScoreInterface(
      'VMware Network Adapter VMnet8',
      '10.165.87.1',
    );
    final ethernet = CompanionLanConfig.companionLanScoreInterface(
      'Ethernet 5',
      '10.165.87.218',
    );
    expect(ethernet, greaterThan(vmware));
    final picked = CompanionLanConfig.pickAdvertisedHostIpv4(
      hostOverride: '',
      addresses: [
        (
          interfaceName: 'VMware Network Adapter VMnet8',
          ipv4: '10.165.87.1',
        ),
        (interfaceName: 'Ethernet 5', ipv4: '10.165.87.218'),
      ],
    );
    expect(picked, '10.165.87.218');
  });
}