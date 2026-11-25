import 'package:core/api/api.dart';
import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';

  late SaleService saleService;

  setUp(() async {
    final products = InMemoryProductRepository();
    final sales = InMemorySaleRepository();
    final movements = InMemoryStockMovementRepository();
    final shifts = InMemoryShiftRepository();
    await products.save(
      Product.create(
        id: 'p1',
        storeId: storeId,
        name: 'A',
        salePriceClp: 600,
        initialStock: 5,
      ),
    );
    await products.save(
      Product.create(
        id: 'p2',
        storeId: storeId,
        name: 'B',
        salePriceClp: 600,
        initialStock: 5,
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
    await sales.save(
      Sale(
        id: 'sale_api',
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
      productRepository: products,
      saleRepository: sales,
      stockMovementRepository: movements,
      shiftRepository: shifts,
      sessionProvider: InMemorySessionProvider.supervisor(),
    );
  });

  test('SC-090-01 API register 201', () async {
    final result = await saleService.registerProductExchange(
      storeId,
      'sale_api',
      const RegisterProductExchangeRequest(
        returnProductId: 'p1',
        returnQuantity: 1,
        newProductId: 'p2',
        newQuantity: 1,
      ),
    );
    expect(result, isA<ApiSuccess<RegisterProductExchangeResponse>>());
    expect((result as ApiSuccess<RegisterProductExchangeResponse>).statusCode,
        201);
    expect(result.data.differenceClp, 0);
  });

  test('SC-090-06 API cajero 403', () async {
    final cajero = SaleService(
      saleRepository: InMemorySaleRepository()
        ..save(
          Sale(
            id: 's2',
            storeId: storeId,
            shiftId: 'sh1',
            cartId: 'c2',
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
        ),
      shiftRepository: InMemoryShiftRepository()
        ..save(
          Shift(
            id: 'sh1',
            storeId: storeId,
            openingCashClp: 0,
            openedAt: DateTime.utc(2026, 1, 1),
            status: ShiftStatus.abierto,
          ),
        ),
      sessionProvider: InMemorySessionProvider.cajero(),
    );
    final result = await cajero.registerProductExchange(
      storeId,
      's2',
      const RegisterProductExchangeRequest(
        returnProductId: 'p1',
        returnQuantity: 1,
        newProductId: 'p2',
        newQuantity: 1,
      ),
    );
    expect(result, isA<ApiFailure<RegisterProductExchangeResponse>>());
    expect((result as ApiFailure<RegisterProductExchangeResponse>).statusCode,
        403);
  });
}