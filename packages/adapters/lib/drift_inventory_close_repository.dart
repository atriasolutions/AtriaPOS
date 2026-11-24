import 'package:core/atria_pos_core.dart';
import 'package:drift/drift.dart';

import 'src/database.dart';

class DriftInventoryCloseRepository implements InventoryCloseRepository {
  DriftInventoryCloseRepository(this._db);

  final AppDatabase _db;

  @override
  Future<void> save(InventoryClose close) async {
    await _db.into(_db.inventoryCloses).insertOnConflictUpdate(
          InventoryClosesCompanion.insert(
            id: close.id,
            storeId: close.storeId,
            shiftId: close.shiftId,
            createdAt: close.createdAt.toUtc().toIso8601String(),
            actorUserId: close.actorUserId,
          ),
        );
    for (final line in close.lines) {
      await _db.into(_db.inventoryCloseLines).insertOnConflictUpdate(
            InventoryCloseLinesCompanion.insert(
              id: line.id,
              closeId: close.id,
              productId: line.productId,
              systemStock: line.systemStock,
              countedStock: line.countedStock,
              variance: line.variance,
              unitsSoldInShift: line.unitsSoldInShift,
            ),
          );
    }
  }

  @override
  Future<InventoryClose?> findById(StoreId storeId, InventoryCloseId id) async {
    final row = await (_db.select(_db.inventoryCloses)
          ..where((t) => t.id.equals(id) & t.storeId.equals(storeId)))
        .getSingleOrNull();
    if (row == null) return null;

    final lineRows = await (_db.select(_db.inventoryCloseLines)
          ..where((t) => t.closeId.equals(id)))
        .get();

    return InventoryClose(
      id: row.id,
      storeId: row.storeId,
      shiftId: row.shiftId,
      createdAt: DateTime.parse(row.createdAt).toUtc(),
      actorUserId: row.actorUserId,
      lines: [
        for (final line in lineRows)
          InventoryCloseLine(
            id: line.id,
            productId: line.productId,
            systemStock: line.systemStock,
            countedStock: line.countedStock,
            variance: line.variance,
            unitsSoldInShift: line.unitsSoldInShift,
          ),
      ],
    );
  }
}