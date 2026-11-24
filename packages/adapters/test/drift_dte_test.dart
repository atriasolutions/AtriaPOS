import 'package:adapters/adapters.dart';
import 'package:core/atria_pos_core.dart';
import 'package:drift/native.dart';
import 'package:test/test.dart';

import 'support/drift_seed_seller.dart';

void main() {
  const storeId = 't1';
  late AppDatabase db;
  late DriftProductRepository products;
  late DriftStockMovementRepository movements;
  late DriftSaleRepository sales;
  late DriftShiftRepository shifts;
  late DriftDteQueueRepository dteQueue;
  late InMemoryCartRepository carts;
  late CreateProduct createProduct;
  late OpenShift openShift;
  late CreateCart createCart;
  late AddCartLine addCartLine;
  late ConfirmCheckout confirmCheckout;
  late DriftCollaboratorRepository collaborators;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    products = DriftProductRepository(db);
    movements = DriftStockMovementRepository(db);
    sales = DriftSaleRepository(db);
    shifts = DriftShiftRepository(db);
    dteQueue = DriftDteQueueRepository(db);
    carts = InMemoryCartRepository();
    collaborators = DriftCollaboratorRepository(db);
    await driftSeedDefaultSeller(collaborators, storeId);
    final sessions = InMemorySessionProvider.supervisor();
    createProduct = CreateProduct(products, sessions);
    openShift = OpenShift(shifts);
    createCart = CreateCart(carts, shifts, sessions);
    addCartLine = AddCartLine(carts, products, sessions);
    confirmCheckout = ConfirmCheckout(
      carts,
      products,
      sales,
      movements,
      shifts,
      collaborators,
      FakeDteGateway(mode: FakeDteMode.alwaysFailure),
      dteQueue,
      sessions,
    );
  });

  tearDown(() async {
    await db.close();
  });

  test('SC-051-01 fallo DTE persistido en drift y cola', () async {
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
        sellerCode: 'V01',
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
    expect(stored!.dteStatus, DteStatus.pendienteDte);
    final pending = await dteQueue.listPending(storeId);
    expect(pending, hasLength(1));
    expect(pending.first.saleId, checkout.saleId);
  });
}