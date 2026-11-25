import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';
  late InMemorySaleRepository sales;
  late InMemoryProductRepository products;
  late InMemoryStockMovementRepository movements;
  late InMemoryShiftRepository shifts;
  late InMemoryProductExchangeRepository exchanges;
  late InMemoryCreditNoteRepository creditNotes;
  late RegisterProductExchange register;

  setUp(() async {
    sales = InMemorySaleRepository();
    products = InMemoryProductRepository();
    movements = InMemoryStockMovementRepository();
    shifts = InMemoryShiftRepository();
    exchanges = InMemoryProductExchangeRepository();
    creditNotes = InMemoryCreditNoteRepository();
    register = RegisterProductExchange(
      sales,
      products,
      movements,
      shifts,
      exchanges,
      creditNotes,
      InMemorySessionProvider.supervisor(),
    );
    await shifts.save(
      Shift(
        id: 'sh1',
        storeId: storeId,
        openingCashClp: 0,
        openedAt: DateTime.utc(2026, 1, 1),
        status: ShiftStatus.abierto,
      ),
    );
    await products.save(
      Product.create(
        id: 'p-old',
        storeId: storeId,
        name: 'Pan',
        salePriceClp: 500,
        initialStock: 3,
      ),
    );
    await products.save(
      Product.create(
        id: 'p-new',
        storeId: storeId,
        name: 'Galletas',
        salePriceClp: 500,
        initialStock: 10,
      ),
    );
  });

  Future<Sale> seedSale({
    String id = 'sale_1',
    String shiftId = 'sh1',
    int lineQty = 1,
    int unitPrice = 500,
    DteStatus dte = DteStatus.pendienteDte,
    int? folio,
  }) async {
    final sale = Sale(
      id: id,
      storeId: storeId,
      shiftId: shiftId,
      cartId: 'cart_1',
      lines: [
        SaleLine(
          productId: 'p-old',
          productName: 'Pan',
          quantity: lineQty,
          unitPriceClp: unitPrice,
        ),
      ],
      payments: [
        Payment.create(method: PaymentMethod.efectivo, amountClp: unitPrice * lineQty),
      ],
      totalClp: unitPrice * lineQty,
      changeClp: 0,
      createdAt: DateTime.utc(2026, 1, 2),
      dteStatus: dte,
      folio: folio,
    );
    await sales.save(sale);
    return sale;
  }

  test('SC-090-01 cambio mismo valor', () async {
    await seedSale();
    final result = await register(
      const RegisterProductExchangeInput(
        storeId: storeId,
        saleId: 'sale_1',
        returnProductId: 'p-old',
        returnQuantity: 1,
        newProductId: 'p-new',
        newQuantity: 1,
      ),
    );
    expect(result.exchange.differenceClp, 0);
    expect(result.newSale.totalClp, 500);
    expect(result.returnProductStock, 4);
    expect(result.newProductStock, 9);
    final list = await exchanges.listBySale(storeId, 'sale_1');
    expect(list, hasLength(1));
    expect((await sales.findById(storeId, result.newSale.id))!.lines.first.productId,
        'p-new');
  });

  test('SC-090-02 cambio parcial hasta agotar', () async {
    await seedSale(lineQty: 3);
  await register(
      const RegisterProductExchangeInput(
        storeId: storeId,
        saleId: 'sale_1',
        returnProductId: 'p-old',
        returnQuantity: 2,
        newProductId: 'p-new',
        newQuantity: 2,
      ),
    );
    await register(
      const RegisterProductExchangeInput(
        storeId: storeId,
        saleId: 'sale_1',
        returnProductId: 'p-old',
        returnQuantity: 1,
        newProductId: 'p-new',
        newQuantity: 1,
      ),
    );
    expect(
      () => register(
        const RegisterProductExchangeInput(
          storeId: storeId,
          saleId: 'sale_1',
          returnProductId: 'p-old',
          returnQuantity: 1,
          newProductId: 'p-new',
          newQuantity: 1,
        ),
      ),
      throwsA(isA<ConflictFailure>()),
    );
  });

  test('SC-090-03 diferencia mayor con pago', () async {
    await products.save(
      Product.create(
        id: 'p-premium',
        storeId: storeId,
        name: 'Premium',
        salePriceClp: 900,
        initialStock: 5,
      ),
    );
    await seedSale();
    final result = await register(
      RegisterProductExchangeInput(
        storeId: storeId,
        saleId: 'sale_1',
        returnProductId: 'p-old',
        returnQuantity: 1,
        newProductId: 'p-premium',
        newQuantity: 1,
        differencePayment: const ProductExchangePaymentInput(
          method: PaymentMethod.efectivo,
          amountClp: 400,
        ),
      ),
    );
    expect(result.exchange.differenceClp, 400);
    expect(result.newSale.payments.single.amountClp, 400);
  });

  test('SC-090-04 diferencia menor devolución OTRO', () async {
    await products.save(
      Product.create(
        id: 'p-cheap',
        storeId: storeId,
        name: 'Barato',
        salePriceClp: 300,
        initialStock: 5,
      ),
    );
    await seedSale();
    final result = await register(
      RegisterProductExchangeInput(
        storeId: storeId,
        saleId: 'sale_1',
        returnProductId: 'p-old',
        returnQuantity: 1,
        newProductId: 'p-cheap',
        newQuantity: 1,
        differencePayment: const ProductExchangePaymentInput(
          method: PaymentMethod.otro,
          amountClp: 200,
        ),
      ),
    );
    expect(result.exchange.differenceClp, -200);
    expect(result.exchange.differencePaymentMethod, PaymentMethod.otro);
  });

  test('SC-090-05 venta otro turno', () async {
    await shifts.save(
      Shift(
        id: 'sh-old',
        storeId: storeId,
        openingCashClp: 0,
        openedAt: DateTime.utc(2025, 12, 1),
        status: ShiftStatus.cerrado,
        closedAt: DateTime.utc(2025, 12, 2),
      ),
    );
    await seedSale(shiftId: 'sh-old');
    expect(
      () => register(
        const RegisterProductExchangeInput(
          storeId: storeId,
          saleId: 'sale_1',
          returnProductId: 'p-old',
          returnQuantity: 1,
          newProductId: 'p-new',
          newQuantity: 1,
        ),
      ),
      throwsA(isA<ValidationFailure>()),
    );
  });

  test('SC-090-05b sin turno abierto', () async {
    await seedSale();
    await shifts.save(
      (await shifts.findOpenByStore(storeId))!.close(countedCashClp: 0),
    );
    expect(
      () => register(
        const RegisterProductExchangeInput(
          storeId: storeId,
          saleId: 'sale_1',
          returnProductId: 'p-old',
          returnQuantity: 1,
          newProductId: 'p-new',
          newQuantity: 1,
        ),
      ),
      throwsA(isA<TurnClosedFailure>()),
    );
  });

  test('SC-090-06 cajero sin permiso', () async {
    await seedSale();
    final cajero = RegisterProductExchange(
      sales,
      products,
      movements,
      shifts,
      exchanges,
      creditNotes,
      InMemorySessionProvider.cajero(),
    );
    expect(
      () => cajero(
        const RegisterProductExchangeInput(
          storeId: storeId,
          saleId: 'sale_1',
          returnProductId: 'p-old',
          returnQuantity: 1,
          newProductId: 'p-new',
          newQuantity: 1,
        ),
      ),
      throwsA(isA<ForbiddenFailure>()),
    );
  });

  test('SC-090-07 DTE emitida bloqueada', () async {
    await seedSale(dte: DteStatus.emitida);
    expect(
      () => register(
        const RegisterProductExchangeInput(
          storeId: storeId,
          saleId: 'sale_1',
          returnProductId: 'p-old',
          returnQuantity: 1,
          newProductId: 'p-new',
          newQuantity: 1,
        ),
      ),
      throwsA(isA<ValidationFailure>()),
    );
  });

  test('SC-090-08 stock insuficiente producto nuevo', () async {
    await products.save(
      Product.create(
        id: 'p-empty',
        storeId: storeId,
        name: 'Agotado',
        salePriceClp: 400,
        initialStock: 0,
      ),
    );
    await seedSale();
    expect(
      () => register(
        const RegisterProductExchangeInput(
          storeId: storeId,
          saleId: 'sale_1',
          returnProductId: 'p-old',
          returnQuantity: 1,
          newProductId: 'p-empty',
          newQuantity: 1,
        ),
      ),
      throwsA(isA<InsufficientStockFailure>()),
    );
  });

  test('SC-092-09 cambio con EMITIDA tras NC', () async {
    await seedSale(dte: DteStatus.emitida, lineQty: 2, folio: 1001);

    final issue = IssueCreditNote(
      sales,
      products,
      movements,
      shifts,
      creditNotes,
      FakeDteGateway(),
      InMemoryDteQueueRepository(),
      InMemorySessionProvider.supervisor(),
    );
    final nc = await issue(
      const IssueCreditNoteInput(
        storeId: storeId,
        saleId: 'sale_1',
        lines: [
          IssueCreditNoteLineInput(productId: 'p-old', quantity: 1),
        ],
      ),
    );
    expect(nc.sale.status, SaleStatus.confirmada);

    final result = await register(
      RegisterProductExchangeInput(
        storeId: storeId,
        saleId: 'sale_1',
        returnProductId: 'p-old',
        returnQuantity: 1,
        newProductId: 'p-new',
        newQuantity: 1,
        creditNoteId: nc.creditNote.id,
      ),
    );
    expect(result.exchange.creditNoteId, nc.creditNote.id);
    expect(result.newProductStock, 9);
  });
}