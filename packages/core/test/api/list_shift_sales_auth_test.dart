import 'package:core/api/api.dart';
import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';

  test('cajero no lista ventas del turno', () async {
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
    final service = SaleService(
      shiftRepository: shifts,
      sessionProvider: InMemorySessionProvider.cajero(),
    );
    final result = await service.listShiftSales(storeId);
    expect(result, isA<ApiFailure<ListShiftSalesResponse>>());
    expect((result as ApiFailure).statusCode, 403);
  });
}