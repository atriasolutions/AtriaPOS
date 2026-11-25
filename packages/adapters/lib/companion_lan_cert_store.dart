import 'dart:io';

import 'companion_lan_tls.dart';

/// Persistencia CA/certificado servidor companion (separado de cert SII).
class CompanionLanCertStore {
  CompanionLanCertStore(String basePath)
      : _dir = Directory(
          '$basePath${Platform.pathSeparator}companion-lan',
        );

  final Directory _dir;

  static const _caPem = 'atria-ca.pem';
  static const _caKeyPem = 'atria-ca-key.pem';
  static const _serverPem = 'server.pem';
  static const _serverKeyPem = 'server-key.pem';
  static const _serverIp = 'server-ip.txt';

  Future<({String caPem, String caKeyPem})> loadOrCreateCa() async {
    await _dir.create(recursive: true);
    final caFile = File('${_dir.path}${Platform.pathSeparator}$_caPem');
    final keyFile = File('${_dir.path}${Platform.pathSeparator}$_caKeyPem');
    if (await caFile.exists() && await keyFile.exists()) {
      return (
        caPem: await caFile.readAsString(),
        caKeyPem: await keyFile.readAsString(),
      );
    }
    final ca = CompanionLanTlsMaterial.generateCaPem();
    await caFile.writeAsString(ca.certPem);
    await keyFile.writeAsString(ca.keyPem);
    return (caPem: ca.certPem, caKeyPem: ca.keyPem);
  }

  Future<CompanionLanTlsMaterial> tlsMaterialForServerIp(String ipv4) async {
    final ca = await loadOrCreateCa();
    await _dir.create(recursive: true);
    final ipFile = File('${_dir.path}${Platform.pathSeparator}$_serverIp');
    final certFile = File('${_dir.path}${Platform.pathSeparator}$_serverPem');
    final keyFile = File('${_dir.path}${Platform.pathSeparator}$_serverKeyPem');

    if (await ipFile.exists() &&
        await certFile.exists() &&
        await keyFile.exists()) {
      final savedIp = (await ipFile.readAsString()).trim();
      if (savedIp == ipv4) {
        return CompanionLanTlsMaterial.buildFromPems(
          caPem: ca.caPem,
          caKeyPem: ca.caKeyPem,
          serverCertPem: await certFile.readAsString(),
          serverKeyPem: await keyFile.readAsString(),
        );
      }
    }

    final material = CompanionLanTlsMaterial.resolveServerMaterial(
      caPem: ca.caPem,
      caKeyPem: ca.caKeyPem,
      ipv4: ipv4,
    );
    await certFile.writeAsString(material.serverCertPem);
    await keyFile.writeAsString(material.serverKeyPem);
    await ipFile.writeAsString(ipv4);

    return material;
  }

  /// Versión síncrona para cableado POS al arranque.
  CompanionLanTlsMaterial tlsMaterialForServerIpSync(String ipv4) {
    final ca = loadOrCreateCaSync();
    final ipFile = File('${_dir.path}${Platform.pathSeparator}$_serverIp');
    final certFile = File('${_dir.path}${Platform.pathSeparator}$_serverPem');
    final keyFile = File('${_dir.path}${Platform.pathSeparator}$_serverKeyPem');
    if (ipFile.existsSync() &&
        certFile.existsSync() &&
        keyFile.existsSync() &&
        ipFile.readAsStringSync().trim() == ipv4) {
      return CompanionLanTlsMaterial.buildFromPems(
        caPem: ca.caPem,
        caKeyPem: ca.caKeyPem,
        serverCertPem: certFile.readAsStringSync(),
        serverKeyPem: keyFile.readAsStringSync(),
      );
    }
    final material = CompanionLanTlsMaterial.resolveServerMaterial(
      caPem: ca.caPem,
      caKeyPem: ca.caKeyPem,
      ipv4: ipv4,
    );
    _dir.createSync(recursive: true);
    certFile.writeAsStringSync(material.serverCertPem);
    keyFile.writeAsStringSync(material.serverKeyPem);
    ipFile.writeAsStringSync(ipv4);
    return material;
  }

  ({String caPem, String caKeyPem}) loadOrCreateCaSync() {
    _dir.createSync(recursive: true);
    final caFile = File('${_dir.path}${Platform.pathSeparator}$_caPem');
    final keyFile = File('${_dir.path}${Platform.pathSeparator}$_caKeyPem');
    if (caFile.existsSync() && keyFile.existsSync()) {
      return (caPem: caFile.readAsStringSync(), caKeyPem: keyFile.readAsStringSync());
    }
    final ca = CompanionLanTlsMaterial.generateCaPem();
    caFile.writeAsStringSync(ca.certPem);
    keyFile.writeAsStringSync(ca.keyPem);
    return (caPem: ca.certPem, caKeyPem: ca.keyPem);
  }
}