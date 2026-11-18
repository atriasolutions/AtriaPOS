import '../domain/domain.dart';
import 'ports/stock_movement_repository.dart';

class InMemoryStockMovementRepository implements StockMovementRepository {
  final _movements = <StockMovement>[];

  @override
  Future<void> save(StockMovement movement) async {
    _movements.add(movement);
  }

  @override
  Future<List<StockMovement>> listByProduct(
    StoreId storeId,
    ProductId productId,
  ) async {
    return _movements
        .where((m) => m.storeId == storeId && m.productId == productId)
        .toList();
  }
}