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
  late OpenShift openShift;
  late CreateProduct createProduct;
  late CreateCart createCart;
  late AddCartLine addCartLine;
  late InMemorySessionProvider sessions;
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
    collaborators = InMemoryCollaboratorRepository();
    await seedDefaultSeller(collaborators, storeId);
    await openShift(storeId, 0);
  });

  test('SC-051-02 retry cola → EMITIDA y sale actualizada', () async {
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
    final failGateway = FakeDteGateway(mode: FakeDteMode.alwaysFailure);
    final checkout = ConfirmCheckout(
      carts,
      products,
      sales,
      movements,
      shifts,
      collaborators,
      InMemoryStoreRepository(),
      failGateway,
      dteQueue,
      sessions,
    );
    final result = await checkout(
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
    expect(result.dteStatus, DteStatus.pendienteDte);

    final retry = RetryPendingDte(
      dteQueue,
      sales,
      InMemoryCreditNoteRepository(),
      FakeDteGateway(startingFolio: 2000),
    );
    final retryResult = await retry(storeId);
    expect(retryResult.processed, 1);
    expect(retryResult.failed, 0);

    final sale = await sales.findById(storeId, result.saleId);
    expect(sale!.dteStatus, DteStatus.emitida);
    expect(sale.folio, 2001);
    expect(await dteQueue.listPending(storeId), isEmpty);
  });
}