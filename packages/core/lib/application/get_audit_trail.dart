import '../domain/domain.dart';
import 'auth_helpers.dart';
import 'ports/product_repository.dart';
import 'ports/sale_repository.dart';
import 'ports/session_provider.dart';
import 'ports/stock_movement_repository.dart';
import 'ports/user_repository.dart';

class AuditTrailItem {
  const AuditTrailItem({
    required this.occurredAt,
    required this.category,
    required this.type,
    required this.summary,
    required this.refId,
    this.actorUserId,
  });

  final DateTime occurredAt;
  final AuditCategory category;
  final String type;
  final String? actorUserId;
  final String summary;
  final String refId;
}

class AuditTrail {
  const AuditTrail({
    required this.fromLocal,
    required this.toLocalInclusive,
    required this.items,
  });

  final DateTime fromLocal;
  final DateTime toLocalInclusive;
  final List<AuditTrailItem> items;

  /// Compat RF-070: un solo día.
  DateTime get calendarDayLocal => fromLocal;
}

class GetAuditTrailInput {
  const GetAuditTrailInput({
    required this.storeId,
    required this.fromLocal,
    required this.toLocalInclusive,
    this.categories,
  });

  final StoreId storeId;
  final DateTime fromLocal;
  final DateTime toLocalInclusive;
  final Set<AuditCategory>? categories;
}

class GetAuditTrail {
  GetAuditTrail(
    this._sales,
    this._movements,
    this._products,
    this._users,
    this._sessions,
  );

  final SaleRepository _sales;
  final StockMovementRepository _movements;
  final ProductRepository _products;
  final UserRepository _users;
  final SessionProvider _sessions;

  Future<AuditTrail> call(
    StoreId storeId, {
    DateTime? calendarDayLocal,
    DateTime? fromLocal,
    DateTime? toLocalInclusive,
    Set<AuditCategory>? categories,
  }) async {
    final from = fromLocal ??
        (calendarDayLocal != null
            ? DateTime(
                calendarDayLocal.year,
                calendarDayLocal.month,
                calendarDayLocal.day,
              )
            : DateTime.now());
    final toInclusive = toLocalInclusive ??
        (calendarDayLocal != null
            ? DateTime(
                calendarDayLocal.year,
                calendarDayLocal.month,
                calendarDayLocal.day,
              )
            : DateTime(from.year, from.month, from.day));

    AuditDateRangePolicy.validateInclusiveRange(
      DateTime(from.year, from.month, from.day),
      DateTime(toInclusive.year, toInclusive.month, toInclusive.day),
    );

    return callWithInput(
      GetAuditTrailInput(
        storeId: storeId,
        fromLocal: DateTime(from.year, from.month, from.day),
        toLocalInclusive: DateTime(
          toInclusive.year,
          toInclusive.month,
          toInclusive.day,
        ),
        categories: categories,
      ),
    );
  }

  Future<AuditTrail> callWithInput(GetAuditTrailInput input) async {
    AuthPolicy.require(
      requireActiveSession(_sessions),
      Permission.consultarAuditoria,
    );

    AuditDateRangePolicy.validateInclusiveRange(
      input.fromLocal,
      input.toLocalInclusive,
    );

    final fromInclusive = AuditDateRangePolicy.fromInclusiveUtc(input.fromLocal);
    final toExclusive =
        AuditDateRangePolicy.toExclusiveUtc(input.toLocalInclusive);

    final requested = input.categories ?? AuditCategory.values.toSet();

    final items = <AuditTrailItem>[];

    if (requested.contains(AuditCategory.ventas)) {
      final sales =
          await _sales.listByStoreCreatedBetween(input.storeId, fromInclusive, toExclusive);
      for (final sale in sales) {
        if (sale.isAnulada) continue;
        items.add(
          AuditTrailItem(
            occurredAt: sale.createdAt,
            category: AuditCategory.ventas,
            type: 'CONFIRMA_VENTA',
            actorUserId: sale.confirmedByUserId,
            summary: 'Venta confirmada: \$${sale.totalClp}',
            refId: sale.id,
          ),
        );
      }

      final voided =
          await _sales.listVoidedInRange(input.storeId, fromInclusive, toExclusive);
      for (final sale in voided) {
        items.add(
          AuditTrailItem(
            occurredAt: sale.voidedAt!,
            category: AuditCategory.ventas,
            type: 'ANULA_VENTA',
            actorUserId: sale.voidedByUserId,
            summary: 'Venta anulada: \$${sale.totalClp}',
            refId: sale.id,
          ),
        );
      }
    }

    if (requested.contains(AuditCategory.inventario)) {
      final movements = await _movements.listByStoreCreatedBetween(
        input.storeId,
        fromInclusive,
        toExclusive,
      );
      for (final mov in movements) {
        if (mov.reason == StockAdjustmentReason.venta) continue;
        final product = await _products.findById(input.storeId, mov.productId);
        final productLabel = product?.name ?? mov.productId;
        final reasonLabel = mov.reason.apiValue;
        var summary =
            '$reasonLabel · $productLabel (${mov.delta >= 0 ? '+' : ''}${mov.delta})';
        if (mov.guideRef != null && mov.lotRef != null) {
          summary += ' · Guía ${mov.guideRef} · Lote ${mov.lotRef}';
        }
        items.add(
          AuditTrailItem(
            occurredAt: mov.createdAt,
            category: AuditCategory.inventario,
            type: 'AJUSTE_STOCK',
            actorUserId: mov.actorId,
            summary: summary,
            refId: mov.id,
          ),
        );
      }
    }

    if (requested.contains(AuditCategory.usuarios)) {
      final users = await _users.listByStoreCreatedBetween(
        input.storeId,
        fromInclusive,
        toExclusive,
      );
      for (final user in users) {
        items.add(
          AuditTrailItem(
            occurredAt: user.createdAt,
            category: AuditCategory.usuarios,
            type: 'CREA_USUARIO',
            actorUserId: user.createdByUserId,
            summary:
                'Usuario creado: ${user.username} (${user.role.apiValue})',
            refId: user.id,
          ),
        );
      }
    }

    // PAGOS: stub Transbank (RF-086) — sin ítems en MVP.

    items.sort((a, b) => b.occurredAt.compareTo(a.occurredAt));

    return AuditTrail(
      fromLocal: input.fromLocal,
      toLocalInclusive: input.toLocalInclusive,
      items: items,
    );
  }
}