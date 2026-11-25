import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';
  late InMemorySaleRepository sales;
  late InMemoryShiftRepository shifts;
  late InMemoryProductExchangeRepository exchanges;
  late GetSaleProductExchangeContext getContext;

  setUp(() async {
    sales = InMemorySaleRepository();
    shifts = InMemoryShiftRepository();
    exchanges = InMemoryProductExchangeRepository();
    getContext = GetSaleProductExchangeContext(
      sales,
      shifts,
      exchanges,
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
    await sales.save(
      Sale(
        id: 'sale_1',
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
        createdAt: DateTime.utc(2026, 1, 2),
      ),
    );
  });

  test('SC-091-01 contexto con cantidad disponible', () async {
    final ctx = await getContext(storeId, 'sale_1');
    expect(ctx.lines.single.availableQuantity, 3);
    expect(ctx.lines.single.returnedQuantity, 0);
  });

  test('SC-091-01b parcial ya cambiado reduce disponible', () async {
    await exchanges.save(
      ProductExchange(
        id: 'ex1',
        storeId: storeId,
        shiftId: 'sh1',
        originalSaleId: 'sale_1',
        returnProductId: 'p1',
        returnQuantity: 2,
        originalUnitPriceClp: 500,
        newProductId: 'p2',
        newQuantity: 2,
        newUnitPriceClp: 500,
        creditClp: 1000,
        chargeClp: 1000,
        differenceClp: 0,
        newSaleId: 'sale_2',
        createdAt: DateTime.utc(2026, 1, 3),
        actorUserId: 'u1',
      ),
    );
    final ctx = await getContext(storeId, 'sale_1');
    expect(ctx.lines.single.returnedQuantity, 2);
    expect(ctx.lines.single.availableQuantity, 1);
  });
}