import 'product_id.dart';
import 'stock_movement_id.dart';

class ScanSessionConfirmationLine {
  const ScanSessionConfirmationLine({
    required this.productId,
    required this.quantity,
    required this.stock,
    required this.movementId,
  });

  final ProductId productId;
  final int quantity;
  final int stock;
  final StockMovementId movementId;
}