enum ScanSessionKind {
  receiptScan('receiptScan'),
  countScan('countScan');

  const ScanSessionKind(this.apiValue);

  final String apiValue;

  static ScanSessionKind fromApi(String raw) {
    return ScanSessionKind.values.firstWhere(
      (k) => k.apiValue == raw,
      orElse: () => throw ArgumentError('kind inválido'),
    );
  }
}