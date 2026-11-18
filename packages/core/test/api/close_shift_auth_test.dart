import 'package:core/api/api.dart';
import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';

  test('SC-070-03 cajero no cierra caja', () async {
    final shifts = InMemoryShiftRepository();
    final sales = InMemorySaleRepository();
    final cajeroSessions = InMemorySessionProvider(
      initial: AuthSession(
        userId: 'usr_cajero',
        role: UserRole.cajero,
        expiresAt: DateTime.now().toUtc().add(const Duration(hours: 1)),
      ),
    );
    final supervisorSessions = InMemorySessionProvider.supervisor();
    final openShift = OpenShift(shifts);
    final shift = await openShift(storeId, 0);
    final service = ShiftService(
      shiftRepository: shifts,
      saleRepository: sales,
      sessionProvider: cajeroSessions,
    );
    final result = await service.closeShift(
      storeId,
      shift.id,
      const CloseShiftRequest(countedCashClp: 0),
    );
    expect(result, isA<ApiFailure<CloseShiftResponse>>());
    expect((result as ApiFailure<CloseShiftResponse>).statusCode, 403);
    // supervisor puede cerrar
    final okService = ShiftService(
      shiftRepository: shifts,
      saleRepository: sales,
      sessionProvider: supervisorSessions,
    );
    final ok = await okService.closeShift(
      storeId,
      shift.id,
      const CloseShiftRequest(countedCashClp: 0),
    );
    expect(ok, isA<ApiSuccess<CloseShiftResponse>>());
  });
}