import '../../domain/domain.dart';

abstract class SaleRepository {
  Future<void> save(Sale sale);

  Future<Sale?> findById(StoreId storeId, SaleId saleId);

  Future<List<Sale>> listByShift(StoreId storeId, ShiftId shiftId);

  Future<List<Sale>> listByStoreCreatedBetween(
    StoreId storeId,
    DateTime fromInclusive,
    DateTime toExclusive,
  );

  Future<List<Sale>> listVoidedInRange(
    StoreId storeId,
    DateTime fromInclusive,
    DateTime toExclusive,
  );

  Future<List<ProductSalesRank>> topProductsByUnits(
    StoreId storeId,
    DateTime fromInclusive,
    DateTime toExclusive,
    int limit,
  );
}