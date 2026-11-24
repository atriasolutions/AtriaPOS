import '../domain/domain.dart';
import 'auth_helpers.dart';
import 'ports/cart_repository.dart';
import 'ports/session_provider.dart';
import 'ports/shift_repository.dart';

class CreateCart {
  CreateCart(this._carts, this._shifts, this._sessions);

  final CartRepository _carts;
  final ShiftRepository _shifts;
  final SessionProvider _sessions;

  Future<Cart> call(StoreId storeId) async {
    final session = requireActiveSession(_sessions);
    AuthPolicy.require(session, Permission.vender);
    final openShift = await _shifts.findOpenByStore(storeId);
    final cart = Cart(
      id: newCartId(),
      storeId: storeId,
      lines: const [],
      shiftId: openShift?.id,
    );
    await _carts.save(cart);
    return cart;
  }
}