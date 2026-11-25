import '../../domain/domain.dart';

abstract class CreditNoteRepository {
  Future<void> save(CreditNote note);

  Future<CreditNote?> findById(StoreId storeId, CreditNoteId id);

  Future<List<CreditNote>> listBySale(StoreId storeId, SaleId saleId);

  Future<int> sumCreditedQty(
    StoreId storeId,
    SaleId saleId,
    ProductId productId, {
    bool onlyEmitida = true,
  });
}