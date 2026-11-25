import 'product_id.dart';

class ScanSessionLine {
  const ScanSessionLine({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.lastScannedAt,
  });

  final ProductId productId;
  final String productName;
  final int quantity;
  final DateTime lastScannedAt;

  ScanSessionLine copyWith({
    int? quantity,
    DateTime? lastScannedAt,
  }) {
    return ScanSessionLine(
      productId: productId,
      productName: productName,
      quantity: quantity ?? this.quantity,
      lastScannedAt: lastScannedAt ?? this.lastScannedAt,
    );
  }
}