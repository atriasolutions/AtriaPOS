import '../domain/domain.dart';
import 'ports/shift_repository.dart';

class GetOpenShift {
  GetOpenShift(this._shifts);

  final ShiftRepository _shifts;

  Future<Shift> call(StoreId storeId) async {
    final shift = await _shifts.findOpenByStore(storeId);
    if (shift == null) {
      throw const NotFoundFailure('No hay turno abierto');
    }
    return shift;
  }
}