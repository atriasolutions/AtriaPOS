import '../domain/domain.dart';
import 'auth_helpers.dart';
import 'ports/cart_repository.dart';
import 'ports/session_provider.dart';

class UpdateCartLineQuantity {
  UpdateCartLineQuantity(this._carts, this._sessions);

  final CartRepository _carts;
  final SessionProvider _sessions;

  Future<Cart> call(
    StoreId storeId,
    CartId cartId,
    CartLineId lineId,
    int quantity,
  ) async {
    final session = requireActiveSession(_sessions);
    AuthPolicy.require(session, Permission.vender);
    final cart = await _requireOpenCart(storeId, cartId);
    final exists = cart.lines.any((l) => l.lineId == lineId);
    if (!exists) {
      throw NotFoundFailure(
        'Línea no encontrada',
        details: {'lineId': lineId},
      );
    }
    final updated = cart.updateLine(lineId, quantity);
    await _carts.save(updated);
    return updated;
  }

  Future<Cart> _requireOpenCart(StoreId storeId, CartId cartId) async {
    final cart = await _carts.findById(storeId, cartId);
    if (cart == null) {
      throw NotFoundFailure(
        'Carro no encontrado',
        details: {'cartId': cartId},
      );
    }
    if (cart.status != CartStatus.open) {
      throw const ValidationFailure('El carro ya no está abierto');
    }
    return cart;
  }
}