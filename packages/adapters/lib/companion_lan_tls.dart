import 'dart:convert';
import 'dart:io';

import 'package:basic_utils/basic_utils.dart';

const _caDn = {
  'CN': 'Atria Companion LAN CA',
  'O': 'Atria Solutions SpA',
};

Map<String, String> _serverDnForIp(String ipv4) => {
      'CN': 'Atria Companion',
      'O': 'Atria Solutions SpA',
    };

/// Material TLS para [CompanionLanServer] (DEC-059, SLICE-109).
class CompanionLanTlsMaterial {
  CompanionLanTlsMaterial({
    required this.securityContext,
    required this.caPem,
    required this.serverCertPem,
    required this.serverKeyPem,
  });

  final SecurityContext securityContext;
  final String caPem;
  final String serverCertPem;
  final String serverKeyPem;

  static CompanionLanTlsMaterial forTest({String ip = '127.0.0.1'}) {
    final ca = generateCaPem();
    return resolveServerMaterial(
      caPem: ca.certPem,
      caKeyPem: ca.keyPem,
      ipv4: ip,
    );
  }

  static CompanionLanTlsMaterial buildFromPems({
    required String caPem,
    required String caKeyPem,
    required String serverCertPem,
    required String serverKeyPem,
  }) {
    final ctx = SecurityContext();
    ctx.useCertificateChainBytes(utf8.encode(serverCertPem.trim()));
    ctx.usePrivateKeyBytes(utf8.encode(serverKeyPem));
    return CompanionLanTlsMaterial(
      securityContext: ctx,
      caPem: caPem,
      serverCertPem: serverCertPem,
      serverKeyPem: serverKeyPem,
    );
  }

  static CompanionLanTlsMaterial resolveServerMaterial({
    required String caPem,
    required String caKeyPem,
    required String ipv4,
  }) {
    final server = issueSelfSignedServer(ipv4: ipv4);
    return buildFromPems(
      caPem: server.certPem,
      caKeyPem: server.keyPem,
      serverCertPem: server.certPem,
      serverKeyPem: server.keyPem,
    );
  }

  static bool acceptsTlsPemPair(String certPem, String keyPem) {
    try {
      final ctx = SecurityContext();
      ctx.useCertificateChainBytes(utf8.encode(certPem.trim()));
      ctx.usePrivateKeyBytes(utf8.encode(keyPem.trim()));
      return true;
    } catch (_) {
      return false;
    }
  }

  static ({String certPem, String keyPem}) generateCaPem() {
    final keyPair = CryptoUtils.generateRSAKeyPair(keySize: 2048);
    final private = keyPair.privateKey as RSAPrivateKey;
    final public = keyPair.publicKey as RSAPublicKey;
    final csr = X509Utils.generateRsaCsrPem(_caDn, private, public);
    final cert = X509Utils.generateSelfSignedCertificate(
      private,
      csr,
      3650,
      cA: true,
      pathLenConstraint: 0,
      keyUsage: [
        KeyUsage.KEY_CERT_SIGN,
        KeyUsage.CRL_SIGN,
        KeyUsage.DIGITAL_SIGNATURE,
        KeyUsage.KEY_ENCIPHERMENT,
      ],
    );
    return (
      certPem: cert,
      keyPem: CryptoUtils.encodeRSAPrivateKeyToPem(private),
    );
  }

  static ({String certPem, String keyPem}) issueServerCertificate({
    required String caCertPem,
    required String caKeyPem,
    required String ipv4,
  }) {
    final caPrivate = CryptoUtils.rsaPrivateKeyFromPem(caKeyPem);
    return _issueLeafSignedByCa(caPrivate: caPrivate, ipv4: ipv4);
  }

  static ({String certPem, String keyPem}) issueSelfSignedServer({
    required String ipv4,
  }) {
    final keyPair = CryptoUtils.generateRSAKeyPair(keySize: 2048);
    final serverPrivate = keyPair.privateKey as RSAPrivateKey;
    final serverPublic = keyPair.publicKey as RSAPublicKey;
    final csr = X509Utils.generateRsaCsrPem(
      {'CN': 'Atria Companion LAN'},
      serverPrivate,
      serverPublic,
    );
    final cert = X509Utils.generateSelfSignedCertificate(
      serverPrivate,
      csr,
      825,
      extKeyUsage: [ExtendedKeyUsage.SERVER_AUTH],
      cA: false,
    );
    return (
      certPem: cert,
      keyPem: CryptoUtils.encodeRSAPrivateKeyToPemPkcs1(serverPrivate),
    );
  }

  static ({String certPem, String keyPem}) _issueLeafSignedByCa({
    required RSAPrivateKey caPrivate,
    required String ipv4,
  }) {
    final keyPair = CryptoUtils.generateRSAKeyPair(keySize: 2048);
    final serverPrivate = keyPair.privateKey as RSAPrivateKey;
    final serverPublic = keyPair.publicKey as RSAPublicKey;
    final dn = _serverDnForIp(ipv4);
    final csr = X509Utils.generateRsaCsrPem(dn, serverPrivate, serverPublic);
    final cert = X509Utils.generateSelfSignedCertificate(
      caPrivate,
      csr,
      825,
      issuer: _caDn,
      extKeyUsage: [ExtendedKeyUsage.SERVER_AUTH],
      keyUsage: [KeyUsage.DIGITAL_SIGNATURE, KeyUsage.KEY_ENCIPHERMENT],
      cA: false,
    );
    return (
      certPem: cert,
      keyPem: CryptoUtils.encodeRSAPrivateKeyToPemPkcs1(serverPrivate),
    );
  }
}