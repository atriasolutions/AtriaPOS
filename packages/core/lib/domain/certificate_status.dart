enum CertificateStatus {
  valido('VALIDO'),
  vencido('VENCIDO'),
  noConfigurado('NO_CONFIGURADO');

  const CertificateStatus(this.apiValue);

  final String apiValue;
}