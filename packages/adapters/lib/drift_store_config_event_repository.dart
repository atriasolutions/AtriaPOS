import 'package:core/atria_pos_core.dart';
import 'package:drift/drift.dart';

import 'src/database.dart';

class DriftStoreConfigEventRepository implements StoreConfigEventRepository {
  DriftStoreConfigEventRepository(this._db);

  final AppDatabase _db;

  @override
  Future<void> append(StoreConfigEvent event) async {
    await _db.into(_db.storeConfigEvents).insert(
          StoreConfigEventsCompanion.insert(
            id: event.id,
            storeId: event.storeId,
            actorUserId: event.actorUserId,
            occurredAt: event.occurredAt.toUtc().toIso8601String(),
            summary: event.summary,
          ),
        );
  }

  @override
  Future<List<StoreConfigEvent>> listByStore(
    StoreId storeId, {
    int limit = 50,
  }) async {
    final rows = await (_db.select(_db.storeConfigEvents)
          ..where((t) => t.storeId.equals(storeId))
          ..orderBy([(t) => OrderingTerm.desc(t.occurredAt)])
          ..limit(limit))
        .get();
    return rows
        .map(
          (r) => StoreConfigEvent(
            id: r.id,
            storeId: r.storeId,
            actorUserId: r.actorUserId,
            occurredAt: DateTime.parse(r.occurredAt).toUtc(),
            summary: r.summary,
          ),
        )
        .toList();
  }
}