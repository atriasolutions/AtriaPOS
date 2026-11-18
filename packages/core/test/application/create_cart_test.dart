import 'package:core/application/application.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';
  late InMemoryCartRepository carts;
  late InMemoryShiftRepository shifts;
  late CreateCart createCart;
  late GetCart getCart;

  setUp(() {
    carts = InMemoryCartRepository();
    shifts = InMemoryShiftRepository();
    createCart = CreateCart(carts, shifts);
    getCart = GetCart(carts);
  });

  test('SC-030-01 crea carro vacío', () async {
    final cart = await createCart(storeId);
    final view = await getCart(storeId, cart.id);
    expect(view.cart.lines, isEmpty);
    expect(view.totalClp, 0);
  });
}