class CertificateStatusResponse {
  const CertificateStatusResponse({
    required this.status,
    this.subject,
    this.validFrom,
    this.validTo,
  });

  final String status;
  final String? subject;
  final String? validFrom;
  final String? validTo;
}