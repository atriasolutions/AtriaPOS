import '../domain/domain.dart';
import 'ports/dte_queue_repository.dart';

class InMemoryDteQueueRepository implements DteQueueRepository {
  final _entries = <String, DteQueueEntry>{};

  String _key(StoreId storeId, SaleId saleId) => '$storeId::$saleId';

  @override
  Future<void> enqueue(DteQueueEntry entry) async {
    _entries[_key(entry.storeId, entry.saleId)] = entry;
  }

  @override
  Future<void> save(DteQueueEntry entry) async {
    _entries[_key(entry.storeId, entry.saleId)] = entry;
  }

  @override
  Future<void> remove(StoreId storeId, SaleId saleId) async {
    _entries.remove(_key(storeId, saleId));
  }

  @override
  Future<List<DteQueueEntry>> listPending(StoreId storeId) async {
    return _entries.values.where((e) => e.storeId == storeId).toList();
  }
}