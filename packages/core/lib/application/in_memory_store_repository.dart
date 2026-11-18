import '../domain/domain.dart';
import 'ports/store_repository.dart';

class InMemoryStoreRepository implements StoreRepository {
  final _byId = <StoreId, Store>{};

  @override
  Future<int> count() async => _byId.length;

  @override
  Future<Store?> findActive() async {
    if (_byId.isEmpty) return null;
    return _byId.values.first;
  }

  @override
  Future<Store?> findById(StoreId storeId) async => _byId[storeId];

  @override
  Future<void> save(Store store) async {
    _byId[store.id] = store;
  }
}