import 'package:core/api/api.dart';
import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';
  late SaleService saleService;

  setUp(() async {
    final sales = InMemorySaleRepository();
    final products = InMemoryProductRepository();
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
    await products.save(
      Product.create(
        id: 'p1',
        storeId: storeId,
        name: 'Pan',
        salePriceClp: 500,
        initialStock: 2,
      ),
    );
    await sales.save(
      Sale(
        id: 'sale_api',
        storeId: storeId,
        shiftId: 'sh1',
        cartId: 'c1',
        lines: [
          SaleLine(
            productId: 'p1',
            productName: 'Pan',
            quantity: 1,
            unitPriceClp: 500,
          ),
        ],
        payments: [
          Payment.create(method: PaymentMethod.efectivo, amountClp: 500),
        ],
        totalClp: 500,
        changeClp: 0,
        createdAt: DateTime.utc(2026, 1, 2),
        dteStatus: DteStatus.emitida,
        folio: 42,
      ),
    );
    saleService = SaleService(
      saleRepository: sales,
      productRepository: products,
      shiftRepository: shifts,
      sessionProvider: InMemorySessionProvider.supervisor(),
    );
  });

  test('SC-092 API issue 201', () async {
    final result = await saleService.issueCreditNote(
      storeId,
      'sale_api',
      const IssueCreditNoteRequest(),
    );
    expect(result, isA<ApiSuccess<IssueCreditNoteResponse>>());
    final data = (result as ApiSuccess<IssueCreditNoteResponse>).data;
    expect(data.folio, isNotNull);
    expect(data.saleStatus, SaleStatus.anulada.apiValue);
  });
}