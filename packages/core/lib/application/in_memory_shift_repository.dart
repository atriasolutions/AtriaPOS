import '../domain/domain.dart';
import 'ports/shift_repository.dart';

class InMemoryShiftRepository implements ShiftRepository {
  final _shifts = <ShiftId, Shift>{};

  @override
  Future<void> save(Shift shift) async {
    _shifts[shift.id] = shift;
  }

  @override
  Future<Shift?> findById(StoreId storeId, ShiftId shiftId) async {
    final shift = _shifts[shiftId];
    if (shift == null || shift.storeId != storeId) return null;
    return shift;
  }

  @override
  Future<Shift?> findOpenByStore(StoreId storeId) async {
    for (final shift in _shifts.values) {
      if (shift.storeId == storeId && shift.isOpen) return shift;
    }
    return null;
  }
}