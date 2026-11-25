import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

import '../support/collaborator_fixtures.dart';

class _LastEmitDteGateway implements DteGateway {
  _LastEmitDteGateway(this._inner);

  final FakeDteGateway _inner;
  DteEmitRequest? lastRequest;

  @override
  Future<DteEmitResult> emit(DteEmitRequest request) async {
    lastRequest = request;
    return _inner.emit(request);
  }

  @override
  Future<DteEmitResult> emitCreditNote(DteCreditNoteEmitRequest request) =>
      _inner.emitCreditNote(request);
}

void main() {
  const storeId = 't1';
  late InMemoryCartRepository carts;
  late InMemoryProductRepository products;
  late InMemorySaleRepository sales;
  late InMemoryStockMovementRepository movements;
  late InMemoryShiftRepository shifts;
  late InMemoryCollaboratorRepository collaborators;
  late InMemoryStoreRepository stores;
  late InMemorySessionProvider sessions;
  late OpenShift openShift;
  late CreateProduct createProduct;
  late CreateCart createCart;
  late AddCartLine addCartLine;
  late _LastEmitDteGateway gateway;
  late ConfirmCheckout confirmCheckout;
  late InMemoryDteQueueRepository dteQueue;
  late RetryPendingDte retry;

  Future<({String cartId, int total})> panCart() async {
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
    return (cartId: cart.id, total: 1000);
  }

  ConfirmCheckoutInput _payment(String cartId, {ConfirmCheckoutInput? base}) {
    return ConfirmCheckoutInput(
      storeId: storeId,
      cartId: cartId,
      sellerCode: base?.sellerCode ?? 'V01',
      payments: base?.payments ??
          const [
            CheckoutPaymentInput(
              method: PaymentMethod.efectivo,
              amountClp: 1000,
            ),
          ],
      changeClp: base?.changeClp ?? 0,
      documentKind: base?.documentKind ?? CheckoutDocumentKind.boleta,
      invoiceReceiver: base?.invoiceReceiver,
    );
  }

  setUp(() async {
    carts = InMemoryCartRepository();
    products = InMemoryProductRepository();
    sales = InMemorySaleRepository();
    movements = InMemoryStockMovementRepository();
    shifts = InMemoryShiftRepository();
    collaborators = InMemoryCollaboratorRepository();
    stores = InMemoryStoreRepository();
    await stores.save(
      Store.create(
        id: storeId,
        rutRaw: '12.345.678-5',
        legalName: 'Tienda Demo',
        businessLine: 'Retail',
      ),
    );
    await seedDefaultSeller(collaborators, storeId);
    sessions = InMemorySessionProvider.supervisor();
    openShift = OpenShift(shifts);
    createProduct = CreateProduct(products, sessions);
    createCart = CreateCart(carts, shifts, sessions);
    addCartLine = AddCartLine(carts, products, sessions);
    dteQueue = InMemoryDteQueueRepository();
    gateway = _LastEmitDteGateway(FakeDteGateway());
    confirmCheckout = ConfirmCheckout(
      carts,
      products,
      sales,
      movements,
      shifts,
      collaborators,
      stores,
      gateway,
      dteQueue,
      sessions,
    );
    retry = RetryPendingDte(dteQueue, sales, InMemoryCreditNoteRepository(), gateway);
    await openShift(storeId, 0);
  });

  test('SC-093-01 checkout factura válida persiste receptor y tipo 33', () async {
    final ctx = await panCart();
    final result = await confirmCheckout(
      _payment(
        ctx.cartId,
        base: ConfirmCheckoutInput(
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
          documentKind: CheckoutDocumentKind.factura,
          invoiceReceiver: const ConfirmCheckoutInvoiceReceiverInput(
            rut: '12.345.678-5',
            businessName: 'Cliente SpA',
          ),
        ),
      ),
    );
    expect(result.dteDocumentType, DteDocumentType.factura);
    expect(result.dteStatus, DteStatus.emitida);
    expect(gateway.lastRequest?.documentType, DteDocumentType.factura);
    final stored = await sales.findById(storeId, result.saleId);
    expect(stored!.dteDocumentType, DteDocumentType.factura);
    expect(stored.invoiceReceiver?.businessName, 'Cliente SpA');
    expect(stored.invoiceReceiver?.rut, '12.345.678-5');
  });

  test('SC-093-02 RUT inválido → VALIDACION', () async {
    final ctx = await panCart();
    expect(
      () => confirmCheckout(
        _payment(
          ctx.cartId,
          base: ConfirmCheckoutInput(
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
            documentKind: CheckoutDocumentKind.factura,
            invoiceReceiver: const ConfirmCheckoutInvoiceReceiverInput(
              rut: '12.345.678-0',
              businessName: 'Cliente SpA',
            ),
          ),
        ),
      ),
      throwsA(isA<ValidationFailure>()),
    );
  });

  test('SC-093-03 razón social vacía → VALIDACION', () async {
    final ctx = await panCart();
    expect(
      () => confirmCheckout(
        _payment(
          ctx.cartId,
          base: ConfirmCheckoutInput(
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
            documentKind: CheckoutDocumentKind.factura,
            invoiceReceiver: const ConfirmCheckoutInvoiceReceiverInput(
              rut: '12.345.678-5',
              businessName: '   ',
            ),
          ),
        ),
      ),
      throwsA(isA<ValidationFailure>()),
    );
  });

  test('SC-093-04 checkout boleta por defecto tipo 39', () async {
    final ctx = await panCart();
    final result = await confirmCheckout(_payment(ctx.cartId));
    expect(result.dteDocumentType, DteDocumentType.boleta);
    expect(gateway.lastRequest?.documentType, DteDocumentType.boleta);
  });

  test('SC-093-05 plantilla sin factura → VALIDACION', () async {
    await stores.save(
      Store(
        id: storeId,
        rut: '12.345.678-5',
        legalName: 'Tienda Demo',
        businessLine: 'Retail',
        taxConfig: const TaxConfig(),
        createdAt: DateTime.now().toUtc(),
        posTemplateId: PosTemplateId.barrioMinTest,
      ),
    );
    final ctx = await panCart();
    expect(
      () => confirmCheckout(
        _payment(
          ctx.cartId,
          base: ConfirmCheckoutInput(
            storeId: storeId,
            cartId: ctx.cartId,
            sellerCode: '',
            payments: const [
              CheckoutPaymentInput(
                method: PaymentMethod.efectivo,
                amountClp: 1000,
              ),
            ],
            changeClp: 0,
            documentKind: CheckoutDocumentKind.factura,
            invoiceReceiver: const ConfirmCheckoutInvoiceReceiverInput(
              rut: '12.345.678-5',
              businessName: 'Cliente SpA',
            ),
          ),
        ),
      ),
      throwsA(isA<ValidationFailure>()),
    );
  });

  test('SC-093-06 cola factura pendiente y retry emite', () async {
    gateway = _LastEmitDteGateway(
      FakeDteGateway(mode: FakeDteMode.failOnceThenSuccess),
    );
    confirmCheckout = ConfirmCheckout(
      carts,
      products,
      sales,
      movements,
      shifts,
      collaborators,
      stores,
      gateway,
      dteQueue,
      sessions,
    );
    retry = RetryPendingDte(
      dteQueue,
      sales,
      InMemoryCreditNoteRepository(),
      gateway,
    );
    final ctx = await panCart();
    final result = await confirmCheckout(
      _payment(
        ctx.cartId,
        base: ConfirmCheckoutInput(
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
          documentKind: CheckoutDocumentKind.factura,
          invoiceReceiver: const ConfirmCheckoutInvoiceReceiverInput(
            rut: '12.345.678-5',
            businessName: 'Cliente SpA',
          ),
        ),
      ),
    );
    expect(result.dteStatus, DteStatus.pendienteDte);
    final pending = await dteQueue.listPending(storeId);
    expect(pending.single.documentType, DteDocumentType.factura);
    final retried = await retry(storeId);
    expect(retried.processed, 1);
    final stored = await sales.findById(storeId, result.saleId);
    expect(stored!.dteStatus, DteStatus.emitida);
    expect(stored.dteDocumentType, DteDocumentType.factura);
  });
}