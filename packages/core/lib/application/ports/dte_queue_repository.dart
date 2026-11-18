import '../../domain/domain.dart';

abstract class DteQueueRepository {
  Future<void> enqueue(DteQueueEntry entry);

  Future<void> save(DteQueueEntry entry);

  Future<void> remove(StoreId storeId, SaleId saleId);

  Future<List<DteQueueEntry>> listPending(StoreId storeId);
}