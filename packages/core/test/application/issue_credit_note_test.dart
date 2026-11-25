import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';
  late InMemorySaleRepository sales;
  late InMemoryProductRepository products;
  late InMemoryStockMovementRepository movements;
  late InMemoryShiftRepository shifts;
  late InMemoryCreditNoteRepository creditNotes;
  late InMemoryDteQueueRepository dteQueue;
  late IssueCreditNote issue;

  setUp(() async {
    sales = InMemorySaleRepository();
    products = InMemoryProductRepository();
    movements = InMemoryStockMovementRepository();
    shifts = InMemoryShiftRepository();
    creditNotes = InMemoryCreditNoteRepository();
    dteQueue = InMemoryDteQueueRepository();
    issue = IssueCreditNote(
      sales,
      products,
      movements,
      shifts,
      creditNotes,
      FakeDteGateway(),
      dteQueue,
      InMemorySessionProvider.supervisor(),
    );
    await products.save(
      Product.create(
        id: 'p1',
        storeId: storeId,
        name: 'Pan',
        salePriceClp: 500,
        initialStock: 3,
      ),
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
  });

  Future<Sale> seedEmitida({int qty = 2}) async {
    final sale = Sale(
      id: 'sale_nc',
      storeId: storeId,
      shiftId: 'sh1',
      cartId: 'c1',
      lines: [
        SaleLine(
          productId: 'p1',
          productName: 'Pan',
          quantity: qty,
          unitPriceClp: 500,
        ),
      ],
      payments: [
        Payment.create(method: PaymentMethod.efectivo, amountClp: 500 * qty),
      ],
      totalClp: 500 * qty,
      changeClp: 0,
      createdAt: DateTime.utc(2026, 1, 2),
      dteStatus: DteStatus.emitida,
      folio: 1001,
    );
    await sales.save(sale);
    return sale;
  }

  test('SC-092-01 NC total anula y restaura stock', () async {
    await seedEmitida();
    final result = await issue(
      const IssueCreditNoteInput(storeId: storeId, saleId: 'sale_nc'),
    );
    expect(result.creditNote.folio, isNotNull);
    expect(result.sale.status, SaleStatus.anulada);
    final product = await products.findById(storeId, 'p1');
    expect(product!.stock, 5);
    expect(result.returnedLines.single.quantity, 2);
  });

  test('SC-092-02 NC parcial mantiene venta', () async {
    await seedEmitida();
    final result = await issue(
      const IssueCreditNoteInput(
        storeId: storeId,
        saleId: 'sale_nc',
        lines: [IssueCreditNoteLineInput(productId: 'p1', quantity: 1)],
      ),
    );
    expect(result.sale.status, SaleStatus.confirmada);
    expect(result.creditNote.totalClp, 500);
    final product = await products.findById(storeId, 'p1');
    expect(product!.stock, 4);

    await issue(
      const IssueCreditNoteInput(
        storeId: storeId,
        saleId: 'sale_nc',
        lines: [IssueCreditNoteLineInput(productId: 'p1', quantity: 1)],
      ),
    );
    final sale = await sales.findById(storeId, 'sale_nc');
    expect(sale!.status, SaleStatus.anulada);
  });

  test('SC-092-06 cajero sin permiso', () async {
    await seedEmitida();
    final cajero = IssueCreditNote(
      sales,
      products,
      movements,
      shifts,
      creditNotes,
      FakeDteGateway(),
      dteQueue,
      InMemorySessionProvider.cajero(),
    );
    expect(
      () => cajero(const IssueCreditNoteInput(storeId: storeId, saleId: 'sale_nc')),
      throwsA(isA<ForbiddenFailure>()),
    );
  });

  test('SC-092-05 NC pendiente encola y retry emite', () async {
    await seedEmitida();
    final gateway = FakeDteGateway(mode: FakeDteMode.failOnceThenSuccess);
    issue = IssueCreditNote(
      sales,
      products,
      movements,
      shifts,
      creditNotes,
      gateway,
      dteQueue,
      InMemorySessionProvider.supervisor(),
    );
    final first = await issue(
      const IssueCreditNoteInput(storeId: storeId, saleId: 'sale_nc'),
    );
    expect(first.creditNote.dteStatus, DteStatus.pendienteDte);
    expect(await dteQueue.listPending(storeId), isNotEmpty);

    final retry = RetryPendingDte(dteQueue, sales, creditNotes, gateway);
    await retry(storeId);
    final stored = (await creditNotes.listBySale(storeId, 'sale_nc')).single;
    expect(stored.dteStatus, DteStatus.emitida);
  });

  test('SC-092-07 venta otro turno', () async {
    await seedEmitida();
    final closed = await shifts.findOpenByStore(storeId);
    await shifts.save(closed!.close(countedCashClp: 0));
    await shifts.save(
      Shift(
        id: 'sh_open',
        storeId: storeId,
        openingCashClp: 0,
        openedAt: DateTime.utc(2026, 1, 4),
        status: ShiftStatus.abierto,
      ),
    );
    expect(
      () => issue(const IssueCreditNoteInput(storeId: storeId, saleId: 'sale_nc')),
      throwsA(isA<ValidationFailure>()),
    );
  });

  test('SC-092-08 devolución pura parcial', () async {
    await seedEmitida(qty: 3);
    final result = await issue(
      const IssueCreditNoteInput(
        storeId: storeId,
        saleId: 'sale_nc',
        lines: [IssueCreditNoteLineInput(productId: 'p1', quantity: 2)],
      ),
    );
    expect(result.creditNote.lines.single.quantity, 2);
    expect(result.sale.status, SaleStatus.confirmada);
  });
}