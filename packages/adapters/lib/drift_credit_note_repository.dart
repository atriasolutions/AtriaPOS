import 'package:core/atria_pos_core.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'src/database.dart';

const _lineUuid = Uuid();

class DriftCreditNoteRepository implements CreditNoteRepository {
  DriftCreditNoteRepository(this._db);

  final AppDatabase _db;

  @override
  Future<void> save(CreditNote note) async {
    await _db.into(_db.creditNotes).insertOnConflictUpdate(
          CreditNotesCompanion.insert(
            id: note.id,
            storeId: note.storeId,
            saleId: note.saleId,
            totalClp: note.totalClp,
            dteStatus: note.dteStatus.apiValue,
            folio: Value(note.folio),
            pdfUrl: Value(note.pdfUrl),
            createdAt: note.createdAt.toUtc().toIso8601String(),
            actorUserId: note.actorUserId,
            referencedSaleFolio: note.referencedSaleFolio,
            referencedDocumentType: note.referencedDocumentType,
          ),
        );
    await (_db.delete(_db.creditNoteLines)
          ..where((t) => t.creditNoteId.equals(note.id)))
        .go();
    for (final line in note.lines) {
      await _db.into(_db.creditNoteLines).insert(
            CreditNoteLinesCompanion.insert(
              id: _lineUuid.v4(),
              creditNoteId: note.id,
              productId: line.productId,
              productName: line.productName,
              quantity: line.quantity,
              unitPriceClp: line.unitPriceClp,
            ),
          );
    }
  }

  @override
  Future<CreditNote?> findById(StoreId storeId, CreditNoteId id) async {
    final row = await (_db.select(_db.creditNotes)
          ..where((t) => t.id.equals(id) & t.storeId.equals(storeId)))
        .getSingleOrNull();
    if (row == null) return null;
    return _mapRow(row);
  }

  @override
  Future<List<CreditNote>> listBySale(StoreId storeId, SaleId saleId) async {
    final rows = await (_db.select(_db.creditNotes)
          ..where((t) => t.storeId.equals(storeId) & t.saleId.equals(saleId)))
        .get();
    return [for (final row in rows) await _mapRow(row)];
  }

  @override
  Future<int> sumCreditedQty(
    StoreId storeId,
    SaleId saleId,
    ProductId productId, {
    bool onlyEmitida = true,
  }) async {
    final notes = await listBySale(storeId, saleId);
    var total = 0;
    for (final note in notes) {
      if (onlyEmitida && !note.isEmitida) continue;
      for (final line in note.lines) {
        if (line.productId == productId) {
          total += line.quantity;
        }
      }
    }
    return total;
  }

  Future<CreditNote> _mapRow(CreditNoteRow row) async {
    final lineRows = await (_db.select(_db.creditNoteLines)
          ..where((t) => t.creditNoteId.equals(row.id)))
        .get();
    return CreditNote(
      id: row.id,
      storeId: row.storeId,
      saleId: row.saleId,
      lines: [
        for (final line in lineRows)
          CreditNoteLine(
            productId: line.productId,
            productName: line.productName,
            quantity: line.quantity,
            unitPriceClp: line.unitPriceClp,
          ),
      ],
      totalClp: row.totalClp,
      dteStatus: DteStatus.fromApi(row.dteStatus),
      folio: row.folio,
      pdfUrl: row.pdfUrl,
      createdAt: DateTime.parse(row.createdAt).toUtc(),
      actorUserId: row.actorUserId,
      referencedSaleFolio: row.referencedSaleFolio,
      referencedDocumentType: row.referencedDocumentType,
    );
  }
}