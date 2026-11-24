import 'package:core/atria_pos_core.dart';
import 'package:drift/drift.dart';

import 'src/database.dart';

class DriftCollaboratorRepository implements CollaboratorRepository {
  DriftCollaboratorRepository(this._db);

  final AppDatabase _db;

  @override
  Future<Collaborator?> findById(StoreId storeId, CollaboratorId id) async {
    final row = await (_db.select(_db.collaborators)
          ..where((t) => t.id.equals(id) & t.storeId.equals(storeId)))
        .getSingleOrNull();
    return row == null ? null : _mapRow(row);
  }

  @override
  Future<Collaborator?> findActiveBySellerCode(
    StoreId storeId,
    String sellerCode,
  ) async {
    final code = sellerCode.trim().toUpperCase();
    final row = await (_db.select(_db.collaborators)
          ..where(
            (t) =>
                t.storeId.equals(storeId) &
                t.sellerCode.equals(code) &
                t.active.equals(true),
          ))
        .getSingleOrNull();
    return row == null ? null : _mapRow(row);
  }

  @override
  Future<List<Collaborator>> listByStore(StoreId storeId) async {
    final rows = await (_db.select(_db.collaborators)
          ..where((t) => t.storeId.equals(storeId))
          ..orderBy([(t) => OrderingTerm.asc(t.sellerCode)]))
        .get();
    return rows.map(_mapRow).toList();
  }

  @override
  Future<void> save(Collaborator collaborator) async {
    await _db.into(_db.collaborators).insertOnConflictUpdate(
          CollaboratorsCompanion.insert(
            id: collaborator.id,
            storeId: collaborator.storeId,
            sellerCode: collaborator.sellerCode,
            firstName: collaborator.firstName,
            lastName: collaborator.lastName,
            active: Value(collaborator.active),
          ),
        );
  }

  Collaborator _mapRow(CollaboratorRow row) {
    return Collaborator(
      id: row.id,
      storeId: row.storeId,
      sellerCode: row.sellerCode,
      firstName: row.firstName,
      lastName: row.lastName,
      active: row.active,
    );
  }
}