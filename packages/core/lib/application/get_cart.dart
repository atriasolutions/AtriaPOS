import '../domain/domain.dart';
import 'auth_helpers.dart';
import 'ports/cart_repository.dart';
import 'ports/session_provider.dart';

class CartView {
  const CartView({
    required this.cart,
    required this.totalClp,
  });

  final Cart cart;
  final int totalClp;
}

class GetCart {
  GetCart(this._carts, this._sessions);

  final CartRepository _carts;
  final SessionProvider _sessions;

  Future<CartView> call(StoreId storeId, CartId cartId) async {
    final session = requireActiveSession(_sessions);
    AuthPolicy.require(session, Permission.vender);
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