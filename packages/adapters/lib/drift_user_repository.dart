import 'package:core/atria_pos_core.dart';
import 'package:drift/drift.dart';

import 'src/database.dart';

class DriftUserRepository implements UserRepository {
  DriftUserRepository(this._db);

  final AppDatabase _db;

  @override
  Future<User?> findById(StoreId storeId, UserId userId) async {
    final row = await (_db.select(_db.users)
          ..where((t) => t.id.equals(userId) & t.storeId.equals(storeId)))
        .getSingleOrNull();
    return row == null ? null : _mapRow(row);
  }

  @override
  Future<User?> findByUsername(StoreId storeId, String username) async {
    final normalized = username.trim();
    final row = await (_db.select(_db.users)
          ..where(
            (t) => t.storeId.equals(storeId) & t.username.equals(normalized),
          ))
        .getSingleOrNull();
    return row == null ? null : _mapRow(row);
  }

  @override
  Future<List<User>> listByStore(StoreId storeId) async {
    final rows = await (_db.select(_db.users)
          ..where((t) => t.storeId.equals(storeId))
          ..orderBy([(t) => OrderingTerm.asc(t.username)]))
        .get();
    return rows.map(_mapRow).toList();
  }

  @override
  Future<void> save(User user) async {
    await _db.into(_db.users).insertOnConflictUpdate(
          UsersCompanion.insert(
            id: user.id,
            storeId: user.storeId,
            role: user.role.apiValue,
            pinHash: user.pinHash,
            displayName: user.displayName,
            username: user.username,
            firstName: user.firstName,
            lastName: user.lastName,
            userRut: user.rut,
            createdAt: user.createdAt.toUtc().toIso8601String(),
            createdByUserId: Value(user.createdByUserId),
          ),
        );
  }

  @override
  Future<List<User>> listByStoreCreatedBetween(
    StoreId storeId,
    DateTime fromInclusive,
    DateTime toExclusive,
  ) async {
    final fromIso = fromInclusive.toUtc().toIso8601String();
    final toIso = toExclusive.toUtc().toIso8601String();
    final rows = await (_db.select(_db.users)
          ..where(
            (t) =>
                t.storeId.equals(storeId) &
                t.createdAt.isBiggerOrEqualValue(fromIso) &
                t.createdAt.isSmallerThanValue(toIso),
          ))
        .get();
    return rows.map(_mapRow).toList();
  }

  User _mapRow(UserRow row) {
    return User(
      id: row.id,
      storeId: row.storeId,
      role: UserRole.fromApi(row.role),
      pinHash: row.pinHash,
      username: row.username,
      firstName: row.firstName,
      lastName: row.lastName,
      rut: row.userRut,
      createdAt: DateTime.parse(row.createdAt).toUtc(),
      createdByUserId: row.createdByUserId,
    );
  }
}