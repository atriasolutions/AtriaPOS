import '../domain/domain.dart';
import 'auth_helpers.dart';
import 'ports/product_repository.dart';
import 'ports/session_provider.dart';
import 'ports/stock_movement_repository.dart';

class AdjustStockInput {
  const AdjustStockInput({
    required this.storeId,
    required this.productId,
    required this.delta,
    required this.reason,
    this.note,
    this.actorId,
  });

  final StoreId storeId;
  final ProductId productId;
  final int delta;
  final StockAdjustmentReason reason;
  final String? note;
  final String? actorId;
}

class AdjustStockResult {
  const AdjustStockResult({
    required this.productId,
    required this.stock,
    required this.movementId,
  });

  final ProductId productId;
  final int stock;
  final StockMovementId movementId;
}

class AdjustStock {
  AdjustStock(this._products, this._movements, this._sessions);

  final ProductRepository _products;
  final StockMovementRepository _movements;
  final SessionProvider _sessions;

  Future<AdjustStockResult> call(AdjustStockInput input) async {
    final session = requireActiveSession(_sessions);
    AuthPolicy.require(session, Permission.ajustarInventario);
    if (input.reason == StockAdjustmentReason.recepcion) {
      throw const ValidationFailure(
        'Use el ingreso de existencias con guía y lote (stock-receipts)',
      );
    }
    final actorId = input.actorId ?? session.userId;
    final product = await _products.findById(input.storeId, input.productId);
    if (product == null) {
      throw NotFoundFailure(
        'Producto no encontrado',
        details: {'productId': input.productId},
      );
    }

    final movement = StockMovement.record(
      storeId: input.storeId,
      productId: input.productId,
      delta: input.delta,
      reason: input.reason,
      note: input.note,
      actorId: actorId,
    );

    final updated = product.applyStockDelta(input.delta);
    await _products.save(updated);
    await _movements.save(movement);

    return AdjustStockResult(
      productId: updated.id,
      stock: updated.stock,
      movementId: movement.id,
    );
  }
}