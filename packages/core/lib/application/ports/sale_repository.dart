import '../../domain/domain.dart';

abstract class SaleRepository {
  Future<void> save(Sale sale);

  Future<Sale?> findById(StoreId storeId, SaleId saleId);

  Future<List<Sale>> listByShift(StoreId storeId, ShiftId shiftId);
}