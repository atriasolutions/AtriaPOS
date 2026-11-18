import '../../domain/domain.dart';

abstract class CartRepository {
  Future<void> save(Cart cart);

  Future<Cart?> findById(StoreId storeId, CartId cartId);
}