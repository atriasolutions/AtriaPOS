import 'dart:convert';
import 'dart:io';

import 'package:basic_utils/basic_utils.dart';

/// Firma simplificada para envío cert: adjunta sobre XML del documento.
class SiiDteSigner {
  const SiiDteSigner();

  String signXml(String documentXml, {String? certPath, String? password}) {
    if (certPath == null || certPath.isEmpty) {
      return documentXml;
    }
    final file = File(certPath);
    if (!file.existsSync()) {
      return documentXml;
    }
    try {
      if (certPath.toLowerCase().endsWith('.pfx')) {
        final bytes = file.readAsBytesSync();
        final pwd = password ?? '';
        final pems = Pkcs12Utils.parsePkcs12(bytes, password: pwd);
        final subject = pems.isNotEmpty
            ? (X509Utils.x509CertificateFromPem(pems.first)
                    .tbsCertificate
                    ?.subject
                    .toString() ??
                'pfx')
            : 'pfx';
        final digest = base64Encode(utf8.encode(documentXml));
        return '$documentXml<Signature Pfx="true" Subject="$subject" Digest="$digest"/>';
      }
      final pem = file.readAsStringSync();
      final cert = X509Utils.x509CertificateFromPem(pem);
      final subject = cert.tbsCertificate?.subject.toString() ?? 'signed';
      final digest = base64Encode(utf8.encode(documentXml));
      return '$documentXml<Signature Pem="true" Subject="$subject" Digest="$digest"/>';
    } catch (_) {
      return documentXml;
    }
  }

  static String passwordFromEnvironment() {
    const raw = String.fromEnvironment('SII_CERT_PASSWORD');
    return raw;
  }
}