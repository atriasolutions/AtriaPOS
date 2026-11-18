import 'package:adapters/adapters.dart';
import 'package:core/pos_barrio_core.dart';
import 'package:drift/native.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';

  test('SC-032-01 drift: anulación persiste status y stock', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(() async => db.close());
    final products = DriftProductRepository(db);
    final sales = DriftSaleRepository(db);
    final movements = DriftStockMovementRepository(db);
    final shifts = DriftShiftRepository(db);
    final dteQueue = DriftDteQueueRepository(db);

    await products.save(
      Product.create(
        id: 'p1',
        storeId: storeId,
        name: 'Pan',
        salePriceClp: 500,
        initialStock: 8,
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
    final sale = Sale(
      id: 'sale_drift',
      storeId: storeId,
      shiftId: 'sh1',
      cartId: 'c1',
      lines: [
        SaleLine(
          productId: 'p1',
          productName: 'Pan',
          quantity: 3,
          unitPriceClp: 500,
        ),
      ],
      payments: [
        Payment.create(method: PaymentMethod.efectivo, amountClp: 1500),
      ],
      totalClp: 1500,
      changeClp: 0,
      createdAt: DateTime.utc(2026, 1, 1),
      dteStatus: DteStatus.rechazadaSii,
    );
    await sales.save(sale);

    final voidSale = VoidSale(
      sales,
      products,
      movements,
      shifts,
      dteQueue,
      InMemorySessionProvider.supervisor(),
    );
    final updated = await voidSale(storeId, sale.id);
    expect(updated.status, SaleStatus.anulada);

    final reloaded = await sales.findById(storeId, sale.id);
    expect(reloaded!.status, SaleStatus.anulada);

  final stock = await products.findById(storeId, 'p1');
    expect(stock!.stock, 11);
  });
}