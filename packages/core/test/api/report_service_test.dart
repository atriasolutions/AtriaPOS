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

  test('fecha inválida', () async {
    final service = ReportService(
      sessionProvider: InMemorySessionProvider.supervisor(),
    );
    final result = await service.getDailySales(storeId, date: 'mal');
    expect(result, isA<ApiFailure<DailySalesReportResponse>>());
    expect((result as ApiFailure).statusCode, 400);
  });
}