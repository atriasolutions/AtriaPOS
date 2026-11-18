import '../domain/domain.dart';
import 'ports/cart_repository.dart';
import 'ports/shift_repository.dart';

class CreateCart {
  CreateCart(this._carts, this._shifts);

  final CartRepository _carts;
  final ShiftRepository _shifts;

  Future<Cart> call(StoreId storeId) async {
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