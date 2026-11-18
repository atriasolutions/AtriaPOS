import '../domain/domain.dart';
import 'ports/store_repository.dart';

class GetActiveStore {
  GetActiveStore(this._stores);

  final StoreRepository _stores;

  Future<Store> call() async {
    final store = await _stores.findActive();
    if (store == null) {
      throw const NotFoundFailure('No hay tienda configurada');
    }
    return store;
  }
}