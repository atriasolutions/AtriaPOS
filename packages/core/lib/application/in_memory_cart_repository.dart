import '../domain/domain.dart';
import 'ports/cart_repository.dart';

class InMemoryCartRepository implements CartRepository {
  final _carts = <CartId, Cart>{};

  @override
  Future<void> save(Cart cart) async {
    _carts[cart.id] = cart;
  }

  @override
  Future<Cart?> findById(StoreId storeId, CartId cartId) async {
    final cart = _carts[cartId];
    if (cart == null || cart.storeId != storeId) return null;
    return cart;
  }
}