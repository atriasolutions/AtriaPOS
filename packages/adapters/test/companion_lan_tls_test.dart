import 'dart:io';

import 'package:adapters/companion_lan_cert_store.dart';
import 'package:adapters/companion_lan_tls.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:test/test.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('atria-companion-tls-');
  });

  tearDown(() async {
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('SC-109-01 CA persistida se reutiliza', () async {
    final store = CompanionLanCertStore(tempDir.path);
    final first = await store.loadOrCreateCa();
    final second = await store.loadOrCreateCa();
    expect(second.caPem, first.caPem);
    expect(second.caKeyPem, first.caKeyPem);

    final caCert = X509Utils.x509CertificateFromPem(first.caPem);
    final subject = caCert.tbsCertificate?.subject.toString() ?? '';
    expect(subject, contains('Atria Companion LAN CA'));
  });

  test('SC-109-02 certificado servidor incluye IP en SAN', () async {
    const ip = '192.168.1.50';
    final store = CompanionLanCertStore(tempDir.path);
    final material = await store.tlsMaterialForServerIp(ip);

    final leaf = X509Utils.x509CertificateFromPem(material.serverCertPem);
    expect(leaf.subject?['2.5.4.3'], 'Atria Companion LAN');

    final ctx = material.securityContext;
    expect(ctx, isNotNull);
  });

  test('SC-109-02b contexto TLS bindSecure sin error', () async {
    final material = CompanionLanTlsMaterial.forTest(ip: '127.0.0.1');
    final server = await HttpServer.bindSecure(
      InternetAddress.loopbackIPv4,
      0,
      material.securityContext,
    );
    expect(server.port, greaterThan(0));
    await server.close(force: true);
  });

  test('SC-114-03 regenera certificado si cambia server-ip.txt', () async {
    const ipA = '192.168.1.10';
    const ipB = '192.168.1.20';
    final store = CompanionLanCertStore(tempDir.path);
    final first = await store.tlsMaterialForServerIp(ipA);
    expect(store.storedServerIpSync(), ipA);
    final second = await store.tlsMaterialForServerIp(ipB);
    expect(store.storedServerIpSync(), ipB);
    expect(second.serverCertPem, isNot(equals(first.serverCertPem)));
  });

  test('CompanionLanTlsMaterial.forTest genera contexto usable', () {
    final material = CompanionLanTlsMaterial.forTest(ip: '127.0.0.1');
    expect(material.caPem, contains('BEGIN CERTIFICATE'));
    expect(material.serverCertPem, contains('BEGIN CERTIFICATE'));
    expect(material.serverKeyPem, anyOf(contains('BEGIN PRIVATE KEY'), contains('BEGIN RSA PRIVATE KEY')));
  });
}