import 'package:adapters/adapters.dart';
import 'package:core/pos_barrio_core.dart';
import 'package:drift/native.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';
  late AppDatabase db;
  late DriftProductRepository products;
  late DriftStockMovementRepository movements;
  late DriftSaleRepository sales;
  late DriftShiftRepository shifts;
  late InMemoryCartRepository carts;
  late CreateProduct createProduct;
  late OpenShift openShift;
  late CreateCart createCart;
  late AddCartLine addCartLine;
  late ConfirmCheckout confirmCheckout;
  late GetProductStock getProductStock;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    products = DriftProductRepository(db);
    movements = DriftStockMovementRepository(db);
    sales = DriftSaleRepository(db);
    shifts = DriftShiftRepository(db);
    carts = InMemoryCartRepository();
    final sessions = InMemorySessionProvider.supervisor();
    createProduct = CreateProduct(products, sessions);
    openShift = OpenShift(shifts);
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
  });

  tearDown(() async {
    await db.close();
  });

  test('SC-031-01 venta persistida en drift', () async {
    await openShift(storeId, 0);
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
    final checkout = await confirmCheckout(
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
    final stored = await sales.findById(storeId, checkout.saleId);
    expect(stored, isNotNull);
    expect(stored!.totalClp, 1000);
    expect(stored.lines, hasLength(1));
    final stock = await getProductStock(storeId, product.id);
    expect(stock.stock, 8);
  });
}