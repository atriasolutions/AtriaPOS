import '../domain/domain.dart';
import 'ports/product_repository.dart';

class ProductStockView {
  const ProductStockView({
    required this.productId,
    required this.stock,
  });

  final ProductId productId;
  final int stock;
}

class GetProductStock {
  GetProductStock(this._products);

  final ProductRepository _products;

  Future<ProductStockView> call(StoreId storeId, ProductId productId) async {
    final product = await _products.findById(storeId, productId);
    if (product == null) {
      throw NotFoundFailure(
        'Producto no encontrado',
        details: {'productId': productId},
      );
    }
    return ProductStockView(productId: product.id, stock: product.stock);
  }
}