import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';
  late InMemoryShiftRepository shifts;
  late InMemorySaleRepository sales;
  late OpenShift openShift;
  late CloseShift closeShift;

  setUp(() {
    shifts = InMemoryShiftRepository();
    sales = InMemorySaleRepository();
    openShift = OpenShift(shifts);
    final sessions = InMemorySessionProvider.supervisor();
    closeShift = CloseShift(shifts, sales, sessions);
  });

  test('SC-041-01 cierre con venta efectivo', () async {
    final shift = await openShift(storeId, 50000);
    await sales.save(
      Sale(
        id: 'sale1',
        storeId: storeId,
        shiftId: shift.id,
        cartId: 'cart1',
        lines: const [],
        payments: [
          Payment(method: PaymentMethod.efectivo, amountClp: 1000),
        ],
        totalClp: 1000,
        changeClp: 0,
        createdAt: DateTime.utc(2026, 1, 1),
      ),
    );
    final report = await closeShift(storeId, shift.id, 51000);
    expect(report.salesTotalClp, 1000);
    expect(report.expectedCashClp, 51000);
    expect(report.differenceClp, 0);
  });

  test('SC-041-02 cerrar turno inexistente → NO_ENCONTRADO', () async {
    expect(
      () => closeShift(storeId, 'nope', 100),
      throwsA(isA<NotFoundFailure>()),
    );
  });
}