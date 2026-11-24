import 'package:core/atria_pos_core.dart';
import 'package:drift/drift.dart';

import 'src/database.dart';

class DriftStockMovementRepository implements StockMovementRepository {
  DriftStockMovementRepository(this._db);

  final AppDatabase _db;

  @override
  Future<void> save(StockMovement movement) async {
    await _db.into(_db.stockMovements).insert(
          StockMovementsCompanion.insert(
            id: movement.id,
            storeId: movement.storeId,
            productId: movement.productId,
            delta: movement.delta,
            reason: movement.reason.apiValue,
            note: Value(movement.note),
            actorId: Value(movement.actorId),
            createdAt: movement.createdAt.toUtc().toIso8601String(),
            guideRef: Value(movement.guideRef),
            lotRef: Value(movement.lotRef),
          ),
        );
  }

  @override
  Future<List<StockMovement>> listByProduct(
    StoreId storeId,
    ProductId productId,
  ) async {
    final rows = await (_db.select(_db.stockMovements)
          ..where(
            (t) => t.storeId.equals(storeId) & t.productId.equals(productId),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
    return rows.map(_map).toList();
  }

  @override
  Future<List<StockMovement>> listByStoreCreatedBetween(
    StoreId storeId,
    DateTime fromInclusive,
    DateTime toExclusive,
  ) async {
    final fromIso = fromInclusive.toUtc().toIso8601String();
    final toIso = toExclusive.toUtc().toIso8601String();
    final rows = await (_db.select(_db.stockMovements)
          ..where(
            (t) =>
                t.storeId.equals(storeId) &
                t.createdAt.isBiggerOrEqualValue(fromIso) &
                t.createdAt.isSmallerThanValue(toIso),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
    return rows.map(_map).toList();
  }

  StockMovement _map(StockMovementRow row) => StockMovement(
        id: row.id,
        storeId: row.storeId,
        productId: row.productId,
        delta: row.delta,
        reason: StockAdjustmentReason.fromApi(row.reason),
        note: row.note,
        actorId: row.actorId,
        guideRef: row.guideRef,
        lotRef: row.lotRef,
        createdAt: DateTime.parse(row.createdAt).toUtc(),
      );
}