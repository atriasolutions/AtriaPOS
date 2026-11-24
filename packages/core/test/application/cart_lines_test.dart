import 'package:core/application/application.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';
  late InMemoryCartRepository carts;
  late InMemoryProductRepository products;
  late CreateProduct createProduct;
  late InMemoryShiftRepository shifts;
  late CreateCart createCart;
  late AddCartLine addCartLine;
  late UpdateCartLineQuantity updateLine;
  late RemoveCartLine removeLine;
  late GetCart getCart;
  late InMemorySessionProvider sessions;

  setUp(() {
    carts = InMemoryCartRepository();
    products = InMemoryProductRepository();
    sessions = InMemorySessionProvider.supervisor();
    createProduct = CreateProduct(products, sessions);
    shifts = InMemoryShiftRepository();
    createCart = CreateCart(carts, shifts, sessions);
    addCartLine = AddCartLine(carts, products, sessions);
    updateLine = UpdateCartLineQuantity(carts, sessions);
    removeLine = RemoveCartLine(carts, sessions);
    getCart = GetCart(carts, sessions);
  });

  Future<String> productPan() async {
    final p = await createProduct(
      const CreateProductInput(
        storeId: storeId,
        name: 'Pan',
        salePriceClp: 500,
        initialStock: 10,
      ),
    );
    return p.id;
  }

  test('SC-030-02 agregar línea y total', () async {
    final productId = await productPan();
    final cart = await createCart(storeId);
    await addCartLine(
      AddCartLineInput(
        storeId: storeId,
        cartId: cart.id,
        productId: productId,
        quantity: 2,
      ),
    );
    final view = await getCart(storeId, cart.id);
    expect(view.totalClp, 1000);
  });

  test('SC-030-03 actualizar cantidad y quitar línea', () async {
    final productId = await productPan();
    final cart = await createCart(storeId);
    final withLine = await addCartLine(
      AddCartLineInput(
        storeId: storeId,
        cartId: cart.id,
        productId: productId,
        quantity: 2,
      ),
    );
    final lineId = withLine.lines.single.lineId;
    await updateLine(storeId, cart.id, lineId, 1);
    var view = await getCart(storeId, cart.id);
    expect(view.totalClp, 500);
    await removeLine(storeId, cart.id, lineId);
    view = await getCart(storeId, cart.id);
    expect(view.cart.lines, isEmpty);
  });
}