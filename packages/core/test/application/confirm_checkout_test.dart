import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';
  late InMemoryCartRepository carts;
  late InMemoryProductRepository products;
  late InMemorySaleRepository sales;
  late InMemoryStockMovementRepository movements;
  late InMemoryShiftRepository shifts;
  late OpenShift openShift;
  late CreateProduct createProduct;
  late CreateCart createCart;
  late AddCartLine addCartLine;
  late ConfirmCheckout confirmCheckout;
  late GetProductStock getProductStock;

  setUp(() async {
    carts = InMemoryCartRepository();
    products = InMemoryProductRepository();
    sales = InMemorySaleRepository();
    movements = InMemoryStockMovementRepository();
    shifts = InMemoryShiftRepository();
    openShift = OpenShift(shifts);
    final sessions = InMemorySessionProvider.supervisor();
    createProduct = CreateProduct(products, sessions);
    createCart = CreateCart(carts, shifts);
    addCartLine = AddCartLine(carts, products);
    confirmCheckout = ConfirmCheckout(
      carts,
      products,
      sales,
      movements,
      shifts,
      FakeDteGateway(),
      InMemoryDteQueueRepository(),
    );
    getProductStock = GetProductStock(products);
    await openShift(storeId, 0);
  });

  Future<({String cartId, String productId})> panCart() async {
    final product = await createProduct(
      const CreateProductInput(
        storeId: storeId,
        name: 'Pan',
        salePriceClp: 500,
        initialStock: 10,
      ),
    );
    final cart = await createCart(storeId);
    await addCartLine(
      AddCartLineInput(
        storeId: storeId,
        cartId: cart.id,
        productId: product.id,
        quantity: 2,
      ),
    );
    return (cartId: cart.id, productId: product.id);
  }

  test('SC-031-01 checkout efectivo exacto', () async {
    final ctx = await panCart();
    final result = await confirmCheckout(
      ConfirmCheckoutInput(
        storeId: storeId,
        cartId: ctx.cartId,
        payments: const [
          CheckoutPaymentInput(
            method: PaymentMethod.efectivo,
            amountClp: 1000,
          ),
        ],
        changeClp: 0,
      ),
    );
    expect(result.totalClp, 1000);
    final stock = await getProductStock(storeId, ctx.productId);
    expect(stock.stock, 8);
    final audit = await movements.listByProduct(storeId, ctx.productId);
    expect(audit.first.reason, StockAdjustmentReason.venta);
  });

  test('SC-031-02 carro vacío → VALIDACION', () async {
    final cart = await createCart(storeId);
    expect(
      () => confirmCheckout(
        ConfirmCheckoutInput(
          storeId: storeId,
          cartId: cart.id,
          payments: const [
            CheckoutPaymentInput(
              method: PaymentMethod.efectivo,
              amountClp: 100,
            ),
          ],
          changeClp: 0,
        ),
      ),
      throwsA(isA<ValidationFailure>()),
    );
  });

  test('SC-031-03 stock insuficiente', () async {
    final product = await createProduct(
      const CreateProductInput(
        storeId: storeId,
        name: 'Pan',
        salePriceClp: 500,
        initialStock: 1,
      ),
    );
    final cart = await createCart(storeId);
    await addCartLine(
      AddCartLineInput(
        storeId: storeId,
        cartId: cart.id,
        productId: product.id,
        quantity: 2,
      ),
    );
    expect(
      () => confirmCheckout(
        ConfirmCheckoutInput(
          storeId: storeId,
          cartId: cart.id,
          payments: const [
            CheckoutPaymentInput(
              method: PaymentMethod.efectivo,
              amountClp: 1000,
            ),
          ],
          changeClp: 0,
        ),
      ),
      throwsA(isA<InsufficientStockFailure>()),
    );
  });

  test('SC-031-04 pago insuficiente → VALIDACION', () async {
    final ctx = await panCart();
    expect(
      () => confirmCheckout(
        ConfirmCheckoutInput(
          storeId: storeId,
          cartId: ctx.cartId,
          payments: const [
            CheckoutPaymentInput(
              method: PaymentMethod.efectivo,
              amountClp: 500,
            ),
          ],
          changeClp: 0,
        ),
      ),
      throwsA(isA<ValidationFailure>()),
    );
  });

  test('SC-031-05 checkout sin turno → TURNO_CERRADO', () async {
    final closeShifts = InMemoryShiftRepository();
    final closeSales = InMemorySaleRepository();
    final checkout = ConfirmCheckout(
      carts,
      products,
      closeSales,
      movements,
      closeShifts,
      FakeDteGateway(),
      InMemoryDteQueueRepository(),
    );
    final ctx = await panCart();
    expect(
      () => checkout(
        ConfirmCheckoutInput(
          storeId: storeId,
          cartId: ctx.cartId,
          payments: const [
            CheckoutPaymentInput(
              method: PaymentMethod.efectivo,
              amountClp: 1000,
            ),
          ],
          changeClp: 0,
        ),
      ),
      throwsA(isA<TurnClosedFailure>()),
    );
  });
}