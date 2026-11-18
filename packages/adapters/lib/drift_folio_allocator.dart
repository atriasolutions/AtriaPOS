import 'package:core/pos_barrio_core.dart';
import 'package:drift/drift.dart';

import 'caf_file.dart';
import 'folio_allocator.dart';
import 'src/database.dart';

class DriftFolioAllocator implements FolioAllocator {
  DriftFolioAllocator(
    this._db, {
    Future<CafRange?> Function()? loadCaf,
  }) : _loadCaf = loadCaf ?? CafFile.loadFromEnvironment;

  final AppDatabase _db;
  final Future<CafRange?> Function() _loadCaf;

  @override
  Future<int> allocateNext(StoreId storeId, int documentType) {
    return _db.transaction(() async {
      final existing = await (_db.select(_db.dteFolioCounters)
            ..where(
              (t) =>
                  t.storeId.equals(storeId) & t.documentType.equals(documentType),
            ))
          .getSingleOrNull();

      if (existing == null) {
        final caf = await _loadCaf();
        if (caf == null || caf.documentType != documentType) {
          throw FolioAgotadoException('CAF no configurado para tipo $documentType');
        }
        await _db.into(_db.dteFolioCounters).insert(
              DteFolioCountersCompanion.insert(
                storeId: storeId,
                documentType: documentType,
                nextFolio: caf.desde,
                cafDesde: caf.desde,
                cafHasta: caf.hasta,
              ),
            );
        return _allocateExisting(storeId, documentType);
      }
      return _allocateFromRow(existing);
    });
  }

  Future<int> _allocateExisting(StoreId storeId, int documentType) async {
    final row = await (_db.select(_db.dteFolioCounters)
          ..where(
            (t) =>
                t.storeId.equals(storeId) & t.documentType.equals(documentType),
          ))
        .getSingle();
    return _allocateFromRow(row);
  }

  Future<int> _allocateFromRow(DteFolioCounterRow row) async {
    final folio = row.nextFolio;
    if (folio > row.cafHasta) {
      throw FolioAgotadoException('Rango CAF agotado (${row.cafDesde}-${row.cafHasta})');
    }
    await (_db.update(_db.dteFolioCounters)
          ..where(
            (t) =>
                t.storeId.equals(row.storeId) &
                t.documentType.equals(row.documentType),
          ))
        .write(
      DteFolioCountersCompanion(
        nextFolio: Value(folio + 1),
      ),
    );
    return folio;
  }
}