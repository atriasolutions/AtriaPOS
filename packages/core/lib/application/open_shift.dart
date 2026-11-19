import '../domain/domain.dart';
import 'ports/shift_repository.dart';
import 'ports/trusted_clock.dart';

class OpenShift {
  OpenShift(this._shifts, [TrustedClock? clock])
      : _clock = clock ?? MutableTrustedClock();

  final ShiftRepository _shifts;
  final TrustedClock _clock;

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
      openedAt: _clock.now(),
    );
    await _shifts.save(shift);
    return shift;
  }
}