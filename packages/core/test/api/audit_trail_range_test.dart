import 'package:core/api/api.dart';
import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';

  test('SC-086-06 legacy date= devuelve fromDate y toDate', () async {
    final sales = InMemorySaleRepository();
    final movements = InMemoryStockMovementRepository();
    final service = ReportService(
      saleRepository: sales,
      stockMovementRepository: movements,
      sessionProvider: InMemorySessionProvider.supervisor(),
    );
    const day = '2026-03-18';
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
    final result = await service.getAuditTrail(storeId, date: day);
    expect(result, isA<ApiSuccess<AuditTrailResponse>>());
    final data = (result as ApiSuccess<AuditTrailResponse>).data;
    expect(data.date, day);
    expect(data.fromDate, day);
    expect(data.toDate, day);
    expect(data.items.single.category, 'INVENTARIO');
  });

  test('SC-086-05 categories=PAGOS lista vacía', () async {
    final service = ReportService(
      sessionProvider: InMemorySessionProvider.supervisor(),
    );
    final result = await service.getAuditTrail(
      storeId,
      from: '2026-03-01',
      to: '2026-03-07',
      categories: 'PAGOS',
    );
    expect(result, isA<ApiSuccess<AuditTrailResponse>>());
    expect((result as ApiSuccess).data.items, isEmpty);
  });

  test('SC-086-02 rango mayor a 31 días → 400', () async {
    final service = ReportService(
      sessionProvider: InMemorySessionProvider.supervisor(),
    );
    final result = await service.getAuditTrail(
      storeId,
      from: '2026-03-01',
      to: '2026-04-05',
    );
    expect(result, isA<ApiFailure<AuditTrailResponse>>());
    expect((result as ApiFailure).statusCode, 400);
  });
}