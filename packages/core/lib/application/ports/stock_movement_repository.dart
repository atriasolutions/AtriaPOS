import '../../domain/domain.dart';

abstract class StockMovementRepository {
  Future<void> save(StockMovement movement);

  Future<List<StockMovement>> listByProduct(
    StoreId storeId,
    ProductId productId,
  );

  Future<List<StockMovement>> listByStoreCreatedBetween(
    StoreId storeId,
    DateTime fromInclusive,
    DateTime toExclusive,
  );
}