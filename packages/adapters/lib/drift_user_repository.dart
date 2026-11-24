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
    if (row == null) return null;
    return User(
      id: row.id,
      storeId: row.storeId,
      role: UserRole.fromApi(row.role),
      pinHash: row.pinHash,
      displayName: row.displayName,
    );
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
          ),
        );
  }
}