import '../domain/domain.dart';
import 'ports/store_repository.dart';

class GetPosTemplate {
  GetPosTemplate(this._stores);

  final StoreRepository _stores;

  Future<PosTemplate> call(StoreId storeId) async {
    final store = await _stores.findById(storeId);
    if (store == null) {
      throw NotFoundFailure(
        'Tienda no encontrada',
        details: {'storeId': storeId},
      );
    }
    return StoreOperationalConfigResolver.effectiveTemplate(store);
  }
}