import '../domain/domain.dart';
import 'ports/store_config_event_repository.dart';

class InMemoryStoreConfigEventRepository implements StoreConfigEventRepository {
  final _events = <StoreConfigEvent>[];

  @override
  Future<void> append(StoreConfigEvent event) async {
    _events.add(event);
  }

  @override
  Future<List<StoreConfigEvent>> listByStore(
    StoreId storeId, {
    int limit = 50,
  }) async {
    return _events
        .where((e) => e.storeId == storeId)
        .toList()
        .reversed
        .take(limit)
        .toList();
  }
}