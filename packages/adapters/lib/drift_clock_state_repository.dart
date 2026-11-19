import 'package:core/application/ports/trusted_clock.dart';
import 'package:drift/drift.dart';

import 'src/database.dart';

class DriftClockStateRepository {
  DriftClockStateRepository(this._db);

  final AppDatabase _db;
  static const defaultId = 'default';

  Future<ClockStateSnapshot?> load() async {
    final row = await (_db.select(_db.clockState)
          ..where((t) => t.id.equals(defaultId)))
        .getSingleOrNull();
    if (row == null) return null;
    return ClockStateSnapshot(
      offset: Duration(microseconds: row.offsetMicroseconds),
      lastSyncAt: row.lastSyncAt == null
          ? null
          : DateTime.parse(row.lastSyncAt!).toUtc(),
      source: row.source == 'shoa'
          ? TrustedClockSource.shoa
          : TrustedClockSource.device,
      isDegraded: row.degraded,
    );
  }

  Future<void> save(ClockStateSnapshot snapshot) async {
    await _db.into(_db.clockState).insertOnConflictUpdate(
          ClockStateCompanion.insert(
            id: defaultId,
            offsetMicroseconds: Value(snapshot.offset.inMicroseconds),
            lastSyncAt: Value(snapshot.lastSyncAt?.toUtc().toIso8601String()),
            source: Value(
              snapshot.source == TrustedClockSource.shoa ? 'shoa' : 'device',
            ),
            degraded: Value(snapshot.isDegraded),
          ),
        );
  }
}

class ClockStateSnapshot {
  const ClockStateSnapshot({
    required this.offset,
    required this.source,
    required this.isDegraded,
    this.lastSyncAt,
  });

  final Duration offset;
  final TrustedClockSource source;
  final bool isDegraded;
  final DateTime? lastSyncAt;
}