import 'package:core/pos_barrio_core.dart';
import 'package:drift/drift.dart';

import 'src/database.dart';

class DriftDteQueueRepository implements DteQueueRepository {
  DriftDteQueueRepository(this._db);

  final AppDatabase _db;

  @override
  Future<void> enqueue(DteQueueEntry entry) async {
    await _db.into(_db.dteQueue).insert(
          DteQueueCompanion.insert(
            saleId: entry.saleId,
            storeId: entry.storeId,
            attempts: Value(entry.attempts),
            lastError: Value(entry.lastError),
            createdAt: entry.createdAt.toUtc().toIso8601String(),
          ),
        );
  }

  @override
  Future<void> save(DteQueueEntry entry) async {
    await (_db.update(_db.dteQueue)..where((t) => t.saleId.equals(entry.saleId)))
        .write(
      DteQueueCompanion(
        attempts: Value(entry.attempts),
        lastError: Value(entry.lastError),
      ),
    );
  }

  @override
  Future<void> remove(StoreId storeId, SaleId saleId) async {
    await (_db.delete(_db.dteQueue)
          ..where((t) => t.saleId.equals(saleId) & t.storeId.equals(storeId)))
        .go();
  }

  @override
  Future<List<DteQueueEntry>> listPending(StoreId storeId) async {
    final rows = await (_db.select(_db.dteQueue)
          ..where((t) => t.storeId.equals(storeId)))
        .get();
    return rows
        .map(
          (r) => DteQueueEntry(
            saleId: r.saleId,
            storeId: r.storeId,
            attempts: r.attempts,
            lastError: r.lastError,
            createdAt: DateTime.parse(r.createdAt).toUtc(),
          ),
        )
        .toList();
  }
}