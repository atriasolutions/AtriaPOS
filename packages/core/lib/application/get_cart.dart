import '../domain/domain.dart';
import 'ports/cart_repository.dart';

class CartView {
  const CartView({
    required this.cart,
    required this.totalClp,
  });

  final Cart cart;
  final int totalClp;
}

class GetCart {
  GetCart(this._carts);

  final CartRepository _carts;

  Future<CartView> call(StoreId storeId, CartId cartId) async {
    final cart = await _carts.findById(storeId, cartId);
    if (cart == null) {
      throw NotFoundFailure(
        'Carro no encontrado',
        details: {'cartId': cartId},
      );
    }
    return CartView(cart: cart, totalClp: saleTotalClp(cart.lines));
  }
}