import 'certificate_status.dart';

/// Metadatos públicos del certificado (sin clave privada ni PIN).
class CertificateInfo {
  CertificateInfo({
    required this.subject,
    required this.validFrom,
    required this.validTo,
    required this.status,
  });

  final String subject;
  final DateTime validFrom;
  final DateTime validTo;
  final CertificateStatus status;

  bool get isValid =>
      status == CertificateStatus.valido &&
      !DateTime.now().toUtc().isBefore(validFrom) &&
      DateTime.now().toUtc().isBefore(validTo);
}