import '../domain/domain.dart';
import 'ports/credit_note_repository.dart';

class InMemoryCreditNoteRepository implements CreditNoteRepository {
  final _notes = <String, CreditNote>{};

  String _key(StoreId storeId, CreditNoteId id) => '$storeId::$id';

  @override
  Future<void> save(CreditNote note) async {
    _notes[_key(note.storeId, note.id)] = note;
  }

  @override
  Future<CreditNote?> findById(StoreId storeId, CreditNoteId id) async {
    return _notes[_key(storeId, id)];
  }

  @override
  Future<List<CreditNote>> listBySale(StoreId storeId, SaleId saleId) async {
    return _notes.values
        .where((n) => n.storeId == storeId && n.saleId == saleId)
        .toList();
  }

  @override
  Future<int> sumCreditedQty(
    StoreId storeId,
    SaleId saleId,
    ProductId productId, {
    bool onlyEmitida = true,
  }) async {
    var total = 0;
    for (final note in await listBySale(storeId, saleId)) {
      if (onlyEmitida && !note.isEmitida) continue;
      for (final line in note.lines) {
        if (line.productId == productId) {
          total += line.quantity;
        }
      }
    }
    return total;
  }
}