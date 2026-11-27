import 'package:core/atria_pos_core.dart';
import 'package:drift/drift.dart';

import 'src/database.dart';

class DriftStoreRepository implements StoreRepository {
  DriftStoreRepository(this._db);

  final AppDatabase _db;

  @override
  Future<int> count() async {
    final rows = await _db.select(_db.stores).get();
    return rows.length;
  }

  @override
  Future<Store?> findActive() async {
    final rows = await _db.select(_db.stores).get();
    if (rows.isEmpty) return null;
    return _map(rows.first);
  }

  @override
  Future<Store?> findById(StoreId storeId) async {
    final row = await (_db.select(_db.stores)
          ..where((t) => t.id.equals(storeId)))
        .getSingleOrNull();
    if (row == null) return null;
    return _map(row);
  }

  @override
  Future<void> save(Store store) async {
    await _db.into(_db.stores).insert(
          StoresCompanion.insert(
            id: store.id,
            rut: store.rut,
            legalName: store.legalName,
            businessLine: store.businessLine,
            taxConfig: store.taxConfig.toJsonString(),
            createdAt: store.createdAt.toUtc().toIso8601String(),
            posTemplateId: Value(store.posTemplateId.apiValue),
            operationalConfig: store.operationalOverrides == null
                ? const Value.absent()
                : Value(store.operationalOverrides!.toJsonString()),
          ),
          onConflict: DoUpdate(
            (old) => StoresCompanion(
              rut: Value(store.rut),
              legalName: Value(store.legalName),
              businessLine: Value(store.businessLine),
              taxConfig: Value(store.taxConfig.toJsonString()),
              posTemplateId: Value(store.posTemplateId.apiValue),
              operationalConfig: store.operationalOverrides == null
                  ? const Value(null)
                  : Value(store.operationalOverrides!.toJsonString()),
            ),
          ),
        );
  }

  Store _map(StoreRow row) {
    return Store(
      id: row.id,
      rut: row.rut,
      legalName: row.legalName,
      businessLine: row.businessLine,
      taxConfig: TaxConfig.parse(row.taxConfig),
      createdAt: DateTime.parse(row.createdAt).toUtc(),
      posTemplateId: PosTemplateId.normalize(row.posTemplateId),
      operationalOverrides: StoreOperationalOverrides.parseJsonString(
        row.operationalConfig,
      ),
    );
  }
}