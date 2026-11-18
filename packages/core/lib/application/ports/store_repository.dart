import '../../domain/domain.dart';

abstract class StoreRepository {
  Future<Store?> findById(StoreId storeId);

  /// Tienda activa en el dispositivo (MVP: única fila).
  Future<Store?> findActive();

  Future<int> count();

  Future<void> save(Store store);
}