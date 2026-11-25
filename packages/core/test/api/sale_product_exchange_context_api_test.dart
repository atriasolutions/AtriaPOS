import 'package:core/api/api.dart';
import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';
  late SaleService saleService;

  setUp(() async {
    final sales = InMemorySaleRepository();
    final shifts = InMemoryShiftRepository();
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
        id: 'sale_ctx',
        storeId: storeId,
        shiftId: 'sh1',
        cartId: 'c1',
        lines: [
          SaleLine(
            productId: 'p1',
            productName: 'A',
            quantity: 1,
            unitPriceClp: 600,
          ),
        ],
        payments: [
          Payment.create(method: PaymentMethod.efectivo, amountClp: 600),
        ],
        totalClp: 600,
        changeClp: 0,
        createdAt: DateTime.utc(2026, 1, 2),
      ),
    );
    saleService = SaleService(
      saleRepository: sales,
      shiftRepository: shifts,
      sessionProvider: InMemorySessionProvider.supervisor(),
    );
  });

  test('SC-091-02 API context 200', () async {
    final result =
        await saleService.getSaleProductExchangeContext(storeId, 'sale_ctx');
    expect(result, isA<ApiSuccess<SaleProductExchangeContextResponse>>());
    expect(
      (result as ApiSuccess<SaleProductExchangeContextResponse>).data.lines,
      hasLength(1),
    );
  });
}