import '../domain/domain.dart';
import 'auth_helpers.dart';
import 'ports/dte_queue_repository.dart';
import 'ports/product_repository.dart';
import 'ports/sale_repository.dart';
import 'ports/session_provider.dart';
import 'ports/shift_repository.dart';
import 'ports/stock_movement_repository.dart';

class VoidSale {
  VoidSale(
    this._sales,
    this._products,
    this._movements,
    this._shifts,
    this._dteQueue,
    this._sessions,
  );

  final SaleRepository _sales;
  final ProductRepository _products;
  final StockMovementRepository _movements;
  final ShiftRepository _shifts;
  final DteQueueRepository _dteQueue;
  final SessionProvider _sessions;

  Future<Sale> call(StoreId storeId, SaleId saleId) async {
    AuthPolicy.require(
      requireActiveSession(_sessions),
      Permission.anularVenta,
    );

    final sale = await _sales.findById(storeId, saleId);
    if (sale == null) {
      throw NotFoundFailure(
        'Venta no encontrada',
        details: {'saleId': saleId},
      );
    }
    if (sale.isAnulada) {
      throw const ConflictFailure('La venta ya está anulada');
    }
    if (sale.dteStatus == DteStatus.emitida) {
      throw const ValidationFailure(
        'No se puede anular una venta con boleta emitida. '
        'Registre nota de crédito en el POS.',
      );
    }

    final openShift = await _shifts.findOpenByStore(storeId);
    if (openShift == null) {
      throw const TurnClosedFailure(
        'No hay turno abierto. No se puede anular en este momento.',
      );
    }
    if (sale.shiftId != openShift.id) {
      throw const ValidationFailure(
        'Solo se pueden anular ventas del turno abierto actual',
      );
    }

    final actorId = requireActiveSession(_sessions).userId;
    for (final line in sale.lines) {
      final product = await _products.findById(storeId, line.productId);
      if (product == null) {
        throw NotFoundFailure(
          'Producto no encontrado',
          details: {'productId': line.productId},
        );
      }
      final updated = product.applyStockDelta(line.quantity);
      await _products.save(updated);
      await _movements.save(
        StockMovement.record(
          storeId: storeId,
          productId: line.productId,
          delta: line.quantity,
          reason: StockAdjustmentReason.anulacionVenta,
          note: 'Anulación venta $saleId',
          actorId: actorId,
        ),
      );
    }

    if (sale.dteStatus == DteStatus.pendienteDte) {
      await _dteQueue.remove(storeId, saleId);
    }

    final anulada = sale.markAnulada(
      voidedAt: DateTime.now().toUtc(),
      voidedByUserId: actorId,
    );
    await _sales.save(anulada);
    return anulada;
  }
}