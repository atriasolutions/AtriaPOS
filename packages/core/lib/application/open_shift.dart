import '../domain/domain.dart';
import 'ports/shift_repository.dart';

class OpenShift {
  OpenShift(this._shifts);

  final ShiftRepository _shifts;

  Future<Shift> call(StoreId storeId, int openingCashClp) async {
    final open = await _shifts.findOpenByStore(storeId);
    if (open != null) {
      throw const ConflictFailure(
        'Ya hay un turno abierto en esta tienda',
      );
    }
    final shift = Shift.open(
      storeId: storeId,
      openingCashClp: openingCashClp,
    );
    await _shifts.save(shift);
    return shift;
  }
}