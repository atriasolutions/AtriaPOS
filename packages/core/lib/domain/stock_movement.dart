import 'failures.dart';
import 'product_id.dart';
import 'stock_adjustment_reason.dart';
import 'stock_movement_id.dart';
import 'store_id.dart';

class StockMovement {
  StockMovement({
    required this.id,
    required this.storeId,
    required this.productId,
    required this.delta,
    required this.reason,
    required this.createdAt,
    this.note,
    this.actorId,
    this.guideRef,
    this.lotRef,
  });

  final StockMovementId id;
  final StoreId storeId;
  final ProductId productId;
  final int delta;
  final StockAdjustmentReason reason;
  final String? note;
  final String? actorId;
  final String? guideRef;
  final String? lotRef;
  final DateTime createdAt;

  static StockMovement record({
    required StoreId storeId,
    required ProductId productId,
    required int delta,
    required StockAdjustmentReason reason,
    String? note,
    String? actorId,
    String? guideRef,
    String? lotRef,
    DateTime? createdAt,
  }) {
    if (delta == 0) {
      throw const ValidationFailure('El ajuste de stock no puede ser cero');
    }

    return StockMovement(
      id: newStockMovementId(),
      storeId: storeId,
      productId: productId,
      delta: delta,
      reason: reason,
      note: note?.trim().isEmpty == true ? null : note?.trim(),
      actorId: actorId,
      guideRef: guideRef,
      lotRef: lotRef,
      createdAt: createdAt ?? DateTime.now().toUtc(),
    );
  }
}