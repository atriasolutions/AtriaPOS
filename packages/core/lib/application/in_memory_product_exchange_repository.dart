import '../domain/domain.dart';
import 'ports/product_exchange_repository.dart';

class InMemoryProductExchangeRepository implements ProductExchangeRepository {
  final _items = <ProductExchangeId, ProductExchange>{};

  @override
  Future<void> save(ProductExchange exchange) async {
    _items[exchange.id] = exchange;
  }

  @override
  Future<List<ProductExchange>> listBySale(
    StoreId storeId,
    SaleId saleId,
  ) async {
  return _items.values
        .where((e) => e.storeId == storeId && e.originalSaleId == saleId)
        .toList();
  }

  @override
  Future<int> sumReturnedQty(
    StoreId storeId,
    SaleId saleId,
    ProductId productId,
  ) async {
    var sum = 0;
    for (final exchange in _items.values) {
      if (exchange.storeId == storeId &&
          exchange.originalSaleId == saleId &&
          exchange.returnProductId == productId) {
        sum += exchange.returnQuantity;
      }
    }
    return sum;
  }
}