import 'package:core/pos_barrio_core.dart';
import 'package:drift/drift.dart';

import 'src/database.dart';

class DriftShiftRepository implements ShiftRepository {
  DriftShiftRepository(this._db);

  final AppDatabase _db;

  @override
  Future<void> save(Shift shift) async {
    await _db.into(_db.shifts).insertOnConflictUpdate(
          ShiftsCompanion(
            id: Value(shift.id),
            storeId: Value(shift.storeId),
            openingCashClp: Value(shift.openingCashClp),
            countedCashClp: Value(shift.countedCashClp),
            status: Value(_statusToDb(shift.status)),
            openedAt: Value(shift.openedAt.toUtc().toIso8601String()),
            closedAt: Value(shift.closedAt?.toUtc().toIso8601String()),
          ),
        );
  }

  @override
  Future<Shift?> findById(StoreId storeId, ShiftId shiftId) async {
    final row = await (_db.select(_db.shifts)
          ..where((t) => t.id.equals(shiftId) & t.storeId.equals(storeId)))
        .getSingleOrNull();
    return row == null ? null : _map(row);
  }

  @override
  Future<Shift?> findOpenByStore(StoreId storeId) async {
    final row = await (_db.select(_db.shifts)
          ..where(
            (t) => t.storeId.equals(storeId) & t.status.equals('ABIERTO'),
          ))
        .getSingleOrNull();
    return row == null ? null : _map(row);
  }

  Shift _map(ShiftRow row) => Shift(
        id: row.id,
        storeId: row.storeId,
        openingCashClp: row.openingCashClp,
        openedAt: DateTime.parse(row.openedAt).toUtc(),
        status: row.status == 'ABIERTO'
            ? ShiftStatus.abierto
            : ShiftStatus.cerrado,
        closedAt:
            row.closedAt == null ? null : DateTime.parse(row.closedAt!).toUtc(),
        countedCashClp: row.countedCashClp,
      );

  String _statusToDb(ShiftStatus status) =>
      status == ShiftStatus.abierto ? 'ABIERTO' : 'CERRADO';
}