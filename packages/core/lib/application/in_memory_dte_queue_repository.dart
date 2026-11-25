import '../domain/domain.dart';
import 'ports/dte_queue_repository.dart';

class InMemoryDteQueueRepository implements DteQueueRepository {
  final _entries = <String, DteQueueEntry>{};

  String _key(DteQueueEntry entry) => '${entry.storeId}::${entry.documentId}';

  @override
  Future<void> enqueue(DteQueueEntry entry) async {
    _entries[_key(entry)] = entry;
  }

  @override
  Future<void> save(DteQueueEntry entry) async {
    _entries[_key(entry)] = entry;
  }

  @override
  Future<void> remove(StoreId storeId, String documentId) async {
    _entries.remove('$storeId::$documentId');
  }

  @override
  Future<List<DteQueueEntry>> listPending(StoreId storeId) async {
    return _entries.values.where((e) => e.storeId == storeId).toList();
  }
}