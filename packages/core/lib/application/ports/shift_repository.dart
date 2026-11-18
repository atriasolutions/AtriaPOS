import '../../domain/domain.dart';

abstract class ShiftRepository {
  Future<void> save(Shift shift);

  Future<Shift?> findById(StoreId storeId, ShiftId shiftId);

  Future<Shift?> findOpenByStore(StoreId storeId);
}