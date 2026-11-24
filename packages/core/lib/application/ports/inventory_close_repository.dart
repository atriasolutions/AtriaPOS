import '../../domain/domain.dart';

abstract class InventoryCloseRepository {
  Future<void> save(InventoryClose close);

  Future<InventoryClose?> findById(StoreId storeId, InventoryCloseId id);
}