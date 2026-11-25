import '../../domain/domain.dart';

abstract class ProductExchangeRepository {
  Future<void> save(ProductExchange exchange);

  Future<List<ProductExchange>> listBySale(StoreId storeId, SaleId saleId);

  Future<int> sumReturnedQty(
    StoreId storeId,
    SaleId saleId,
    ProductId productId,
  );
}