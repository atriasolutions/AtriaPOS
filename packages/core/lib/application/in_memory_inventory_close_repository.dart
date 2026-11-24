import '../domain/domain.dart';
import 'ports/inventory_close_repository.dart';

class InMemoryInventoryCloseRepository implements InventoryCloseRepository {
  final _byId = <InventoryCloseId, InventoryClose>{};

  @override
  Future<void> save(InventoryClose close) async {
    _byId[close.id] = close;
  }

  @override
  Future<InventoryClose?> findById(StoreId storeId, InventoryCloseId id) async {
    final close = _byId[id];
    if (close == null || close.storeId != storeId) return null;
    return close;
  }
}