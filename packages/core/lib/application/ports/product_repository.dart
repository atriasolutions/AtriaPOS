import '../../domain/domain.dart';

abstract class ProductRepository {
  Future<void> save(Product product);

  Future<Product?> findById(StoreId storeId, ProductId id);

  Future<Product?> findByBarcode(StoreId storeId, String barcode);

  Future<List<Product>> search(StoreId storeId, String query);
}