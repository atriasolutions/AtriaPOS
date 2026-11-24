import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

import '../support/collaborator_fixtures.dart';

void main() {
  const storeId = 't1';
  late InMemoryCartRepository carts;
  late InMemoryProductRepository products;
  late InMemorySaleRepository sales;
  late InMemoryStockMovementRepository movements;
  late InMemoryShiftRepository shifts;
  late InMemoryDteQueueRepository dteQueue;
  late InMemorySessionProvider sessions;
  late OpenShift openShift;
  late CreateProduct createProduct;
  late CreateCart createCart;
  late AddCartLine addCartLine;
  late GetProductStock getProductStock;
  late InMemoryCollaboratorRepository collaborators;

  setUp(() async {
    carts = InMemoryCartRepository();
    products = InMemoryProductRepository();
    sales = InMemorySaleRepository();
    movements = InMemoryStockMovementRepository();
    shifts = InMemoryShiftRepository();
    dteQueue = InMemoryDteQueueRepository();
    openShift = OpenShift(shifts);
    sessions = InMemorySessionProvider.supervisor();
    createProduct = CreateProduct(products, sessions);
    createCart = CreateCart(carts, shifts, sessions);
    addCartLine = AddCartLine(carts, products, sessions);
    getProductStock = GetProductStock(products);
    collaborators = InMemoryCollaboratorRepository();
    await seedDefaultSeller(collaborators, storeId);
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

  test('SC-050-01 checkout con DTE ok → EMITIDA y folio', () async {
    final ctx = await panCart();
    final checkout = ConfirmCheckout(
      carts,
      products,
      sales,
      movements,
      shifts,
      collaborators,
      InMemoryStoreRepository(),
      FakeDteGateway(startingFolio: 1000),
      dteQueue,
      sessions,
    );
    final result = await checkout(
      ConfirmCheckoutInput(
        storeId: storeId,
        cartId: ctx.cartId,
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
    expect(result.dteStatus, DteStatus.emitida);
    expect(result.folio, 1001);
    expect(result.pdfUrl, isNull);
    final stored = await sales.findById(storeId, result.saleId);
    expect(stored!.dteStatus, DteStatus.emitida);
    expect(await dteQueue.listPending(storeId), isEmpty);
    final stock = await getProductStock(storeId, ctx.productId);
    expect(stock.stock, 8);
  });

  test('SC-051-01 fallo DTE → PENDIENTE_DTE, stock descontado y cola', () async {
    final ctx = await panCart();
    final checkout = ConfirmCheckout(
      carts,
      products,
      sales,
      movements,
      shifts,
      collaborators,
      InMemoryStoreRepository(),
      FakeDteGateway(mode: FakeDteMode.alwaysFailure),
      dteQueue,
      sessions,
    );
    final result = await checkout(
      ConfirmCheckoutInput(
        storeId: storeId,
        cartId: ctx.cartId,
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
    expect(result.dteStatus, DteStatus.pendienteDte);
    expect(result.folio, isNull);
    final pending = await dteQueue.listPending(storeId);
    expect(pending, hasLength(1));
    expect(pending.first.saleId, result.saleId);
    final stock = await getProductStock(storeId, ctx.productId);
    expect(stock.stock, 8);
  });

  test('SC-051-03 rechazo SII → RECHAZADA_SII sin cola', () async {
    final ctx = await panCart();
    final checkout = ConfirmCheckout(
      carts,
      products,
      sales,
      movements,
      shifts,
      collaborators,
      InMemoryStoreRepository(),
      FakeDteGateway(mode: FakeDteMode.rechazadaSii),
      dteQueue,
      sessions,
    );
    final result = await checkout(
      ConfirmCheckoutInput(
        storeId: storeId,
        cartId: ctx.cartId,
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
    expect(result.dteStatus, DteStatus.rechazadaSii);
    expect(await dteQueue.listPending(storeId), isEmpty);
  });
}