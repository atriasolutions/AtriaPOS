import '../domain/domain.dart';
import 'auth_helpers.dart';
import 'ports/sale_repository.dart';
import 'ports/session_provider.dart';
import 'ports/shift_repository.dart';

class ShiftCloseReport {
  const ShiftCloseReport({
    required this.expectedCashClp,
    required this.countedCashClp,
    required this.differenceClp,
    required this.salesTotalClp,
  });

  final int expectedCashClp;
  final int countedCashClp;
  final int differenceClp;
  final int salesTotalClp;
}

class CloseShift {
  CloseShift(this._shifts, this._sales, this._sessions);

  final ShiftRepository _shifts;
  final SaleRepository _sales;
  final SessionProvider _sessions;

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

    final closed = shift.close(countedCashClp: countedCashClp);
    await _shifts.save(closed);

    return ShiftCloseReport(
      expectedCashClp: expectedCashClp,
      countedCashClp: countedCashClp,
      differenceClp: differenceClp,
      salesTotalClp: salesTotalClp,
    );
  }
}