enum CompanionMode {
  vender,
  receiptScan,
  countScan;

  String get apiValue => switch (this) {
        CompanionMode.vender => 'VENDER',
        CompanionMode.receiptScan => 'RECEIPT_SCAN',
        CompanionMode.countScan => 'COUNT_SCAN',
      };

  static CompanionMode fromApi(String raw) {
    return switch (raw.trim().toUpperCase()) {
      'VENDER' => CompanionMode.vender,
      'RECEIPT_SCAN' => CompanionMode.receiptScan,
      'COUNT_SCAN' => CompanionMode.countScan,
      _ => throw ArgumentError('Modo companion inválido'),
    };
  }
}