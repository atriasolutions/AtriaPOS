import 'product_id.dart';

class ScanSessionInventoryConfirmationLine {
  const ScanSessionInventoryConfirmationLine({
    required this.productId,
    required this.systemStock,
    required this.countedStock,
    required this.variance,
    required this.unitsSoldInShift,
  });

  final ProductId productId;
  final int systemStock;
  final int countedStock;
  final int variance;
  final int unitsSoldInShift;
}