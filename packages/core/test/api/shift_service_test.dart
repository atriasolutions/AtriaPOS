import 'package:core/api/api.dart';
import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';
  late ShiftRepository shifts;
  late SaleRepository sales;
  late ShiftService shiftService;

  setUp(() {
    shifts = InMemoryShiftRepository();
    sales = InMemorySaleRepository();
    shiftService = ShiftService(shiftRepository: shifts, saleRepository: sales);
  });

  test('openShift 201', () async {
    final result = await shiftService.openShift(
      storeId,
      const OpenShiftRequest(openingCashClp: 50000),
    );
    expect(result, isA<ApiSuccess<OpenShiftResponse>>());
  });

  test('getOpenShift 200', () async {
    await shiftService.openShift(
      storeId,
      const OpenShiftRequest(openingCashClp: 1000),
    );
    final result = await shiftService.getOpenShift(storeId);
    expect(result, isA<ApiSuccess<OpenShiftStatusResponse>>());
  });

  test('openShift SC-040-02 segundo → 409 CONFLICTO', () async {
    await shiftService.openShift(
      storeId,
      const OpenShiftRequest(openingCashClp: 1000),
    );
    final result = await shiftService.openShift(
      storeId,
      const OpenShiftRequest(openingCashClp: 2000),
    );
    expect(result, isA<ApiFailure<OpenShiftResponse>>());
    final failure = result as ApiFailure<OpenShiftResponse>;
    expect(failure.statusCode, 409);
    expect(failure.error.code, 'CONFLICTO');
  });

  test('getOpenShift sin turno → 404', () async {
    final result = await shiftService.getOpenShift(storeId);
    expect(result, isA<ApiFailure<OpenShiftStatusResponse>>());
    expect((result as ApiFailure<OpenShiftStatusResponse>).error.code, 'NO_ENCONTRADO');
  });

  test('closeShift SC-041-02 turno inexistente → 404', () async {
    final result = await shiftService.closeShift(
      storeId,
      'nope',
      const CloseShiftRequest(countedCashClp: 100),
    );
    expect(result, isA<ApiFailure<CloseShiftResponse>>());
    expect((result as ApiFailure<CloseShiftResponse>).statusCode, 404);
  });

  test('closeShift SC-041-01 → 200', () async {
    final opened = await shiftService.openShift(
      storeId,
      const OpenShiftRequest(openingCashClp: 50000),
    );
    final shiftId = (opened as ApiSuccess<OpenShiftResponse>).data.shiftId;
    await sales.save(
      Sale(
        id: 'sale1',
        storeId: storeId,
        shiftId: shiftId,
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
    final result = await shiftService.closeShift(
      storeId,
      shiftId,
      const CloseShiftRequest(countedCashClp: 51000),
    );
    expect(result, isA<ApiSuccess<CloseShiftResponse>>());
    final success = result as ApiSuccess<CloseShiftResponse>;
    expect(success.data.salesTotalClp, 1000);
    expect(success.data.expectedCashClp, 51000);
    expect(success.data.differenceClp, 0);
  });
}