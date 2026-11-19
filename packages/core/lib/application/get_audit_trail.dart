import '../domain/domain.dart';
import 'auth_helpers.dart';
import 'ports/product_repository.dart';
import 'ports/sale_repository.dart';
import 'ports/session_provider.dart';
import 'ports/stock_movement_repository.dart';

class AuditTrailItem {
  const AuditTrailItem({
    required this.occurredAt,
    required this.type,
    required this.summary,
    required this.refId,
    this.actorUserId,
  });

  final DateTime occurredAt;
  final String type;
  final String? actorUserId;
  final String summary;
  final String refId;
}

class AuditTrail {
  const AuditTrail({
    required this.calendarDayLocal,
    required this.items,
  });

  final DateTime calendarDayLocal;
  final List<AuditTrailItem> items;
}

class GetAuditTrail {
  GetAuditTrail(
    this._sales,
    this._movements,
    this._products,
    this._sessions,
  );

  final SaleRepository _sales;
  final StockMovementRepository _movements;
  final ProductRepository _products;
  final SessionProvider _sessions;

  Future<AuditTrail> call(
    StoreId storeId, {
    DateTime? calendarDayLocal,
  }) async {
    AuthPolicy.require(
      requireActiveSession(_sessions),
      Permission.anularVenta,
    );

    final dayAnchor = calendarDayLocal ?? DateTime.now();
    final from = DateTime(dayAnchor.year, dayAnchor.month, dayAnchor.day);
    final to = from.add(const Duration(days: 1));

    final sales =
        await _sales.listByStoreCreatedBetween(storeId, from, to);
    final movements = await _movements.listByStoreCreatedBetween(
      storeId,
      from,
      to,
    );

    final items = <AuditTrailItem>[];

    for (final sale in sales) {
      if (sale.isAnulada) continue;
      items.add(
        AuditTrailItem(
          occurredAt: sale.createdAt,
          type: 'CONFIRMA_VENTA',
          actorUserId: sale.confirmedByUserId,
          summary: 'Venta confirmada: \$${sale.totalClp}',
          refId: sale.id,
        ),
      );
    }

    for (final mov in movements) {
      if (mov.reason == StockAdjustmentReason.venta) continue;
      final product = await _products.findById(storeId, mov.productId);
      final productLabel = product?.name ?? mov.productId;
      final reasonLabel = mov.reason.apiValue;
      items.add(
        AuditTrailItem(
          occurredAt: mov.createdAt,
          type: 'AJUSTE_STOCK',
          actorUserId: mov.actorId,
          summary:
              '$reasonLabel · $productLabel (${mov.delta >= 0 ? '+' : ''}${mov.delta})',
          refId: mov.id,
        ),
      );
    }

    items.sort((a, b) => b.occurredAt.compareTo(a.occurredAt));

    return AuditTrail(
      calendarDayLocal: from,
      items: items,
    );
  }
}