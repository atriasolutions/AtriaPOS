import '../domain/domain.dart';
import 'auth_helpers.dart';
import 'ports/product_repository.dart';
import 'ports/session_provider.dart';
import 'ports/stock_movement_repository.dart';

class RecordStockReceiptInput {
  const RecordStockReceiptInput({
    required this.storeId,
    required this.productId,
    required this.quantity,
    required this.guideRef,
    required this.lotRef,
  });

  final StoreId storeId;
  final ProductId productId;
  final int quantity;
  final String guideRef;
  final String lotRef;
}

class RecordStockReceiptResult {
  const RecordStockReceiptResult({
    required this.productId,
    required this.stock,
    required this.movementId,
    required this.guideRef,
    required this.lotRef,
  });

  final ProductId productId;
  final int stock;
  final StockMovementId movementId;
  final String guideRef;
  final String lotRef;
}

class RecordStockReceipt {
  RecordStockReceipt(this._products, this._movements, this._sessions);

  final ProductRepository _products;
  final StockMovementRepository _movements;
  final SessionProvider _sessions;

  Future<RecordStockReceiptResult> call(RecordStockReceiptInput input) async {
    final session = requireActiveSession(_sessions);
    AuthPolicy.require(session, Permission.ajustarInventario);

    if (input.quantity <= 0) {
      throw const ValidationFailure(
        'La cantidad de ingreso debe ser mayor a cero',
      );
    }

    final guideRef = StockReceiptRefPolicy.normalize(input.guideRef);
    final lotRef = StockReceiptRefPolicy.normalize(input.lotRef);

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
      delta: input.quantity,
      reason: StockAdjustmentReason.recepcion,
      guideRef: guideRef,
      lotRef: lotRef,
      actorId: session.userId,
    );

    final updated = product.applyStockDelta(input.quantity);
    await _products.save(updated);
    await _movements.save(movement);

    return RecordStockReceiptResult(
      productId: updated.id,
      stock: updated.stock,
      movementId: movement.id,
      guideRef: guideRef,
      lotRef: lotRef,
    );
  }
}