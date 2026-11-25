import '../../domain/domain.dart';

abstract class DteQueueRepository {
  Future<void> enqueue(DteQueueEntry entry);

  Future<void> save(DteQueueEntry entry);

  Future<void> remove(StoreId storeId, String documentId);

  Future<List<DteQueueEntry>> listPending(StoreId storeId);
}