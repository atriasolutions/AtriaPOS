import 'package:adapters/adapters.dart';
import 'package:core/atria_pos_core.dart';
import 'package:drift/native.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';
  late AppDatabase db;
  late DriftShiftRepository shifts;
  late DriftSaleRepository sales;
  late DriftProductRepository products;
  late DriftStockMovementRepository movements;
  late InMemoryCartRepository carts;
  late OpenShift openShift;
  late CloseShift closeShift;
  late CreateProduct createProduct;
  late CreateCart createCart;
  late AddCartLine addCartLine;
  late ConfirmCheckout confirmCheckout;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    shifts = DriftShiftRepository(db);
    sales = DriftSaleRepository(db);
    products = DriftProductRepository(db);
    movements = DriftStockMovementRepository(db);
    carts = InMemoryCartRepository();
    openShift = OpenShift(shifts);
    final sessions = InMemorySessionProvider.supervisor();
    closeShift = CloseShift(shifts, sales, sessions);
    createProduct = CreateProduct(products, sessions);
    createCart = CreateCart(carts, shifts, sessions);
    addCartLine = AddCartLine(carts, products, sessions);
    confirmCheckout =
        ConfirmCheckout(
          carts,
          products,
          sales,
          movements,
          shifts,
          FakeDteGateway(),
          InMemoryDteQueueRepository(),
          sessions,
        );
  });

  tearDown(() async {
    await db.close();
  });

  test('SC-041-01 flujo turno venta cierre drift', () async {
    final shift = await openShift(storeId, 50000);
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
    await confirmCheckout(
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
    );
    final report = await closeShift(storeId, shift.id, 51000);
    expect(report.expectedCashClp, 51000);
    expect(report.salesTotalClp, 1000);
  });
}