import 'package:core/api/api.dart';
import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';

  test('SC-060-02 API reporte diario', () async {
    final sales = InMemorySaleRepository();
    const day = '2026-03-18';
    await sales.save(
      Sale(
        id: 's1',
        storeId: storeId,
        shiftId: 'sh1',
        cartId: 'c1',
        lines: const [],
        payments: [
          Payment.create(method: PaymentMethod.efectivo, amountClp: 1000),
        ],
        totalClp: 1000,
        changeClp: 0,
        createdAt: DateTime(2026, 3, 18, 10),
      ),
    );
    await sales.save(
      Sale(
        id: 's2',
        storeId: storeId,
        shiftId: 'sh1',
        cartId: 'c2',
        lines: const [],
        payments: [
          Payment.create(method: PaymentMethod.efectivo, amountClp: 1500),
        ],
        totalClp: 1500,
        changeClp: 0,
        createdAt: DateTime(2026, 3, 18, 11),
      ),
    );
    await sales.save(
      Sale(
        id: 's3',
        storeId: storeId,
        shiftId: 'sh1',
        cartId: 'c3',
        lines: const [],
        payments: [
          Payment.create(method: PaymentMethod.efectivo, amountClp: 500),
        ],
        totalClp: 500,
        changeClp: 0,
        createdAt: DateTime(2026, 3, 18, 12),
        status: SaleStatus.anulada,
      ),
    );

    final service = ReportService(
      saleRepository: sales,
      sessionProvider: InMemorySessionProvider.supervisor(),
    );
    final result = await service.getDailySales(storeId, date: day);
    expect(result, isA<ApiSuccess<DailySalesReportResponse>>());
    final data = (result as ApiSuccess<DailySalesReportResponse>).data;
    expect(data.date, day);
    expect(data.salesTotalClp, 2500);
    expect(data.transactionCount, 2);
    expect(data.averageTicketClp, 1250);
  });

  test('SC-070-01 API auditoría del día', () async {
    final sales = InMemorySaleRepository();
    final movements = InMemoryStockMovementRepository();
    final products = InMemoryProductRepository();
    const day = '2026-03-18';
    await products.save(
      Product.create(
        id: 'p1',
        storeId: storeId,
        name: 'Pan',
        salePriceClp: 500,
        initialStock: 10,
      ),
    );
    await sales.save(
      Sale(
        id: 's1',
        storeId: storeId,
        shiftId: 'sh1',
        cartId: 'c1',
        lines: const [],
        payments: [
          Payment.create(method: PaymentMethod.efectivo, amountClp: 500),
        ],
        totalClp: 500,
        changeClp: 0,
        createdAt: DateTime(2026, 3, 18, 10),
        confirmedByUserId: 'usr_supervisor',
      ),
    );
    await movements.save(
      StockMovement(
        id: 'm1',
        storeId: storeId,
        productId: 'p1',
        delta: -1,
        reason: StockAdjustmentReason.merma,
        createdAt: DateTime(2026, 3, 18, 11),
        actorId: 'usr_supervisor',
      ),
    );

    final service = ReportService(
      saleRepository: sales,
      stockMovementRepository: movements,
      productRepository: products,
      sessionProvider: InMemorySessionProvider.supervisor(),
    );
    final result = await service.getAuditTrail(storeId, date: day);
    expect(result, isA<ApiSuccess<AuditTrailResponse>>());
    final data = (result as ApiSuccess<AuditTrailResponse>).data;
    expect(data.date, day);
    expect(data.fromDate, day);
    expect(data.toDate, day);
    expect(data.items.length, 2);
    expect(data.items.every((i) => i.category.isNotEmpty), isTrue);
    expect(
      data.items.any((i) => i.type == 'CONFIRMA_VENTA'),
      isTrue,
    );
    expect(
      data.items.any((i) => i.type == 'AJUSTE_STOCK'),
      isTrue,
    );
  });

  test('fecha inválida', () async {
    final service = ReportService(
      sessionProvider: InMemorySessionProvider.supervisor(),
    );
    final result = await service.getDailySales(storeId, date: 'mal');
    expect(result, isA<ApiFailure<DailySalesReportResponse>>());
    expect((result as ApiFailure).statusCode, 400);
  });
}