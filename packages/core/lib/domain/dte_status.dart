enum DteStatus {
  emitida('EMITIDA'),
  pendienteDte('PENDIENTE_DTE'),
  rechazadaSii('RECHAZADA_SII');

  const DteStatus(this.apiValue);

  final String apiValue;

  static DteStatus fromApi(String value) {
    return DteStatus.values.firstWhere(
      (s) => s.apiValue == value.trim().toUpperCase(),
      orElse: () => DteStatus.pendienteDte,
    );
  }
}