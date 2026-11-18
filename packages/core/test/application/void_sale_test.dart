import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';
  late InMemorySaleRepository sales;
  late InMemoryProductRepository products;
  late InMemoryStockMovementRepository movements;
  late InMemoryShiftRepository shifts;
  late InMemoryDteQueueRepository dteQueue;
  late VoidSale voidSale;

  setUp(() async {
    sales = InMemorySaleRepository();
    products = InMemoryProductRepository();
    movements = InMemoryStockMovementRepository();
    shifts = InMemoryShiftRepository();
    dteQueue = InMemoryDteQueueRepository();
    voidSale = VoidSale(
      sales,
      products,
      movements,
      shifts,
      dteQueue,
      InMemorySessionProvider.supervisor(),
    );
    await products.save(
      Product.create(
        id: 'p1',
        storeId: storeId,
        name: 'Pan',
        salePriceClp: 500,
        initialStock: 5,
      ),
    );
    await shifts.save(
      Shift(
        id: 'sh1',
        storeId: storeId,
        openingCashClp: 10000,
        openedAt: DateTime.utc(2026, 1, 1),
        status: ShiftStatus.abierto,
      ),
    );
  });

  test('SC-032-01 anula y restaura stock', () async {
    final sale = await _seedSale(sales, storeId, 'sh1', dte: DteStatus.rechazadaSii);
    final updated = await voidSale(storeId, sale.id);
    expect(updated.status, SaleStatus.anulada);
    final product = await products.findById(storeId, 'p1');
    expect(product!.stock, 7);
    final audit = await movements.listByProduct(storeId, 'p1');
    expect(audit.length, 1);
    expect(audit.first.reason, StockAdjustmentReason.anulacionVenta);
  });

  test('SC-032-02 cajero sin permiso', () async {
    final cajero = VoidSale(
      sales,
      products,
      movements,
      shifts,
      dteQueue,
      InMemorySessionProvider.cajero(),
    );
    await _seedSale(sales, storeId, 'sh1');
    expect(
      () => cajero(storeId, 'sale_1'),
      throwsA(isA<ForbiddenFailure>()),
    );
  });

  test('SC-032-03 sin turno abierto', () async {
    await shifts.save(
      (await shifts.findOpenByStore(storeId))!.close(countedCashClp: 10000),
    );
    await _seedSale(sales, storeId, 'sh1');
    expect(
      () => voidSale(storeId, 'sale_1'),
      throwsA(isA<TurnClosedFailure>()),
    );
  });

  test('SC-032-04 ya anulada', () async {
    await _seedSale(sales, storeId, 'sh1', status: SaleStatus.anulada);
    expect(
      () => voidSale(storeId, 'sale_1'),
      throwsA(isA<ConflictFailure>()),
    );
  });

  test('SC-032-05 DTE emitida bloqueada', () async {
    await _seedSale(sales, storeId, 'sh1', dte: DteStatus.emitida);
    expect(
      () => voidSale(storeId, 'sale_1'),
      throwsA(isA<ValidationFailure>()),
    );
  });

  test('SC-032-06 pendiente DTE limpia cola', () async {
    await _seedSale(sales, storeId, 'sh1', dte: DteStatus.pendienteDte);
    await dteQueue.enqueue(
      DteQueueEntry(
        saleId: 'sale_1',
        storeId: storeId,
        attempts: 1,
        createdAt: DateTime.utc(2026, 1, 1),
      ),
    );
    await voidSale(storeId, 'sale_1');
    expect(await dteQueue.listPending(storeId), isEmpty);
  });
}

Future<Sale> _seedSale(
  InMemorySaleRepository sales,
  StoreId storeId,
  ShiftId shiftId, {
  SaleStatus status = SaleStatus.confirmada,
  DteStatus dte = DteStatus.pendienteDte,
}) async {
  final sale = Sale(
    id: 'sale_1',
    storeId: storeId,
    shiftId: shiftId,
    cartId: 'cart_1',
    lines: [
      SaleLine(
        productId: 'p1',
        productName: 'Pan',
        quantity: 2,
        unitPriceClp: 500,
      ),
    ],
    payments: [
      Payment.create(method: PaymentMethod.efectivo, amountClp: 1000),
    ],
    totalClp: 1000,
    changeClp: 0,
    createdAt: DateTime.utc(2026, 1, 1),
    status: status,
    dteStatus: dte,
  );
  await sales.save(sale);
  return sale;
}