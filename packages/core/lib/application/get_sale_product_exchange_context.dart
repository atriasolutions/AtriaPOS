import '../domain/domain.dart';
import 'auth_helpers.dart';
import 'ports/product_exchange_repository.dart';
import 'ports/sale_repository.dart';
import 'ports/session_provider.dart';
import 'ports/shift_repository.dart';

class SaleProductExchangeLineContext {
  const SaleProductExchangeLineContext({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPriceClp,
    required this.returnedQuantity,
    required this.availableQuantity,
  });

  final ProductId productId;
  final String productName;
  final int quantity;
  final int unitPriceClp;
  final int returnedQuantity;
  final int availableQuantity;
}

class SaleProductExchangeContext {
  const SaleProductExchangeContext({
    required this.saleId,
    required this.status,
    required this.dteStatus,
    required this.lines,
  });

  final SaleId saleId;
  final SaleStatus status;
  final DteStatus dteStatus;
  final List<SaleProductExchangeLineContext> lines;
}

class GetSaleProductExchangeContext {
  GetSaleProductExchangeContext(
    this._sales,
    this._shifts,
    this._exchanges,
    this._sessions,
  );

  final SaleRepository _sales;
  final ShiftRepository _shifts;
  final ProductExchangeRepository _exchanges;
  final SessionProvider _sessions;

  Future<SaleProductExchangeContext> call(StoreId storeId, SaleId saleId) async {
    AuthPolicy.require(
      requireActiveSession(_sessions),
      Permission.cambiarProducto,
    );

    final sale = await _sales.findById(storeId, saleId);
    if (sale == null) {
      throw NotFoundFailure(
        'Venta no encontrada',
        details: {'saleId': saleId},
      );
    }
    if (sale.isAnulada) {
      throw const ValidationFailure('No se puede cambiar en una venta anulada');
    }

    final openShift = await _shifts.findOpenByStore(storeId);
    if (openShift == null) {
      throw const TurnClosedFailure('No hay turno abierto');
    }
    if (sale.shiftId != openShift.id) {
      throw const ValidationFailure(
        'Solo se pueden cambiar productos en ventas del turno abierto',
      );
    }

    final aggregated = <String, _AggLine>{};
    for (final line in sale.lines) {
      final existing = aggregated[line.productId];
      if (existing == null) {
        aggregated[line.productId] = _AggLine(
          productId: line.productId,
          productName: line.productName,
          quantity: line.quantity,
          unitPriceClp: line.unitPriceClp,
        );
      } else {
        if (existing.unitPriceClp != line.unitPriceClp) {
          throw const ValidationFailure(
            'La venta tiene el mismo producto con precios distintos',
          );
        }
        existing.quantity += line.quantity;
      }
    }

    final lines = <SaleProductExchangeLineContext>[];
    for (final agg in aggregated.values) {
      final returned = await _exchanges.sumReturnedQty(
        storeId,
        saleId,
        agg.productId,
      );
      lines.add(
        SaleProductExchangeLineContext(
          productId: agg.productId,
          productName: agg.productName,
          quantity: agg.quantity,
          unitPriceClp: agg.unitPriceClp,
          returnedQuantity: returned,
          availableQuantity: agg.quantity - returned,
        ),
      );
    }

    return SaleProductExchangeContext(
      saleId: sale.id,
      status: sale.status,
      dteStatus: sale.dteStatus,
      lines: lines,
    );
  }
}

class _AggLine {
  _AggLine({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPriceClp,
  });

  final ProductId productId;
  final String productName;
  int quantity;
  final int unitPriceClp;
}