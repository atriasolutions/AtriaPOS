import '../domain/domain.dart';
import 'auth_helpers.dart';
import 'ports/sale_repository.dart';
import 'ports/session_provider.dart';
import 'ports/shift_repository.dart';
import 'ports/trusted_clock.dart';

class ShiftCloseReport {
  const ShiftCloseReport({
    required this.expectedCashClp,
    required this.countedCashClp,
    required this.differenceClp,
    required this.salesTotalClp,
    required this.openedAt,
    required this.closedAt,
  });

  final int expectedCashClp;
  final int countedCashClp;
  final int differenceClp;
  final int salesTotalClp;
  final DateTime openedAt;
  final DateTime closedAt;
}

class CloseShift {
  CloseShift(this._shifts, this._sales, this._sessions, [TrustedClock? clock])
      : _clock = clock ?? MutableTrustedClock();

  final ShiftRepository _shifts;
  final SaleRepository _sales;
  final SessionProvider _sessions;
  final TrustedClock _clock;

  Future<ShiftCloseReport> call(
    StoreId storeId,
    ShiftId shiftId,
    int countedCashClp,
  ) async {
    AuthPolicy.require(
      requireActiveSession(_sessions),
      Permission.cerrarCaja,
    );
    final shift = await _shifts.findById(storeId, shiftId);
    if (shift == null) {
      throw NotFoundFailure(
        'Turno no encontrado',
        details: {'shiftId': shiftId},
      );
    }
    if (!shift.isOpen) {
      throw const ValidationFailure('El turno ya está cerrado');
    }

    final sales = await _sales.listByShift(storeId, shiftId);
    final salesTotalClp = shiftSalesTotalClp(sales);
    final expectedCashClp =
        shiftExpectedCashClp(shift.openingCashClp, sales);
    final differenceClp = countedCashClp - expectedCashClp;

    final closedAt = _clock.now();
    final closed = shift.close(
      countedCashClp: countedCashClp,
      closedAt: closedAt,
    );
    await _shifts.save(closed);

    return ShiftCloseReport(
      expectedCashClp: expectedCashClp,
      countedCashClp: countedCashClp,
      differenceClp: differenceClp,
      salesTotalClp: salesTotalClp,
      openedAt: shift.openedAt,
      closedAt: closedAt,
    );
  }
}