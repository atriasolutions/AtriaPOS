import 'dart:io';

import 'package:basic_utils/basic_utils.dart';
import 'package:core/atria_pos_core.dart';

/// Lee certificado PEM desde `SII_CERT_PATH` (DEC-021).
class FileCertificateStore implements CertificateStore {
  FileCertificateStore(this._path);

  final String? _path;

  factory FileCertificateStore.fromEnvironment() {
    const path = String.fromEnvironment('SII_CERT_PATH');
    return FileCertificateStore(path.isEmpty ? null : path);
  }

  @override
  Future<CertificateInfo?> loadActiveCertificate(StoreId storeId) async {
    final path = _path;
    if (path == null || path.isEmpty) {
      return null;
    }
    final file = File(path);
    if (!await file.exists()) {
      return null;
    }
    final pem = await file.readAsString();
    if (pem.trim().isEmpty) {
      return null;
    }
    try {
      final cert = X509Utils.x509CertificateFromPem(pem);
      final validFrom = cert.tbsCertificate?.validity.notBefore.toUtc() ??
          DateTime.utc(1970);
      final validTo =
          cert.tbsCertificate?.validity.notAfter.toUtc() ?? DateTime.utc(1970);
      final now = DateTime.now().toUtc();
      final status = now.isBefore(validTo) && !now.isBefore(validFrom)
          ? CertificateStatus.valido
          : CertificateStatus.vencido;
      final subject = cert.tbsCertificate?.subject.toString() ?? 'unknown';
      return CertificateInfo(
        subject: subject,
        validFrom: validFrom,
        validTo: validTo,
        status: status,
      );
    } catch (_) {
      return null;
    }
  }
}