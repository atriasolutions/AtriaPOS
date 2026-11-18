import '../domain/domain.dart';
import 'ports/dte_queue_repository.dart';

class ListPendingDte {
  ListPendingDte(this._queue);

  final DteQueueRepository _queue;

  Future<List<DteQueueEntry>> call(StoreId storeId) {
    return _queue.listPending(storeId);
  }
}