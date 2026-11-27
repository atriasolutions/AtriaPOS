import '../domain/domain.dart';
import 'ports/store_repository.dart';

class StoreOperationalConfigResult {
  const StoreOperationalConfigResult({
    required this.templateId,
    required this.overrides,
    required this.effectiveTemplate,
  });

  final PosTemplateId templateId;
  final StoreOperationalOverrides overrides;
  final PosTemplate effectiveTemplate;
}

class GetStoreOperationalConfig {
  GetStoreOperationalConfig(this._stores);

  final StoreRepository _stores;

  Future<StoreOperationalConfigResult> call(StoreId storeId) async {
    final store = await _stores.findById(storeId);
    if (store == null) {
      throw NotFoundFailure(
        'Tienda no encontrada',
        details: {'storeId': storeId},
      );
    }
    final overrides = store.operationalOverrides ?? StoreOperationalOverrides.empty;
    final effective = StoreOperationalConfigResolver.effectiveTemplate(store);
    return StoreOperationalConfigResult(
      templateId: store.posTemplateId,
      overrides: overrides,
      effectiveTemplate: effective,
    );
  }
}