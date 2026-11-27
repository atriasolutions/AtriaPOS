import '../application/application.dart';
import '../domain/domain.dart';
import 'api_error.dart';
import 'api_result.dart';
import 'store_dtos.dart';

class StoreService {
  factory StoreService({
    StoreRepository? storeRepository,
    UserRepository? userRepository,
    PinHasher? pinHasher,
    SessionProvider? sessionProvider,
    DteQueueRepository? dteQueueRepository,
    StoreConfigEventRepository? storeConfigEventRepository,
  }) {
    final stores = storeRepository ?? InMemoryStoreRepository();
    final users = userRepository ?? InMemoryUserRepository();
    final hasher = pinHasher ?? BcryptPinHasher();
    final sessions = sessionProvider ?? InMemorySessionProvider();
    final dteQueue = dteQueueRepository ?? InMemoryDteQueueRepository();
    final configEvents =
        storeConfigEventRepository ?? InMemoryStoreConfigEventRepository();
    return StoreService._(
      stores,
      users,
      hasher,
      sessions,
      dteQueue,
      configEvents,
    );
  }

  StoreService._(
    StoreRepository stores,
    UserRepository users,
    PinHasher hasher,
    SessionProvider sessions,
    DteQueueRepository dteQueue,
    StoreConfigEventRepository configEvents,
  )   : _bootstrap = BootstrapStore(stores, users, hasher, sessions),
        _getActive = GetActiveStore(stores),
        _getPosTemplate = GetPosTemplate(stores),
        _getOperationalConfig = GetStoreOperationalConfig(stores),
        _updateOperationalConfig = UpdateStoreOperationalConfig(
          stores,
          sessions,
          dteQueue,
          configEvents,
        ),
        _stores = stores;

  final BootstrapStore _bootstrap;
  final GetActiveStore _getActive;
  final GetPosTemplate _getPosTemplate;
  final GetStoreOperationalConfig _getOperationalConfig;
  final UpdateStoreOperationalConfig _updateOperationalConfig;
  final StoreRepository _stores;

  Future<ApiResult<BootstrapStoreResponse>> bootstrap(
    BootstrapStoreRequest request,
  ) async {
    try {
      final result = await _bootstrap(
        BootstrapStoreInput(
          rut: request.rut,
          legalName: request.legalName,
          businessLine: request.businessLine,
          ownerFirstName: request.ownerFirstName,
          ownerLastName: request.ownerLastName,
          ownerUsername: request.ownerUsername,
          ownerRut: request.ownerRut,
          ownerPin: request.ownerPin,
        ),
      );
      return ApiSuccess(
        BootstrapStoreResponse(
          storeId: result.store.id,
          userId: result.user.id,
          token: result.session.token,
          role: result.user.role.apiValue,
          expiresAt: result.session.expiresAt.toUtc().toIso8601String(),
        ),
        statusCode: 201,
      );
    } on ValidationFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 400,
      );
    } on ConflictFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message, details: e.details),
        statusCode: 409,
      );
    }
  }

  Future<ApiResult<ActiveStoreResponse>> getActiveStore() async {
    try {
      final store = await _getActive();
      return ApiSuccess(
        ActiveStoreResponse(
          storeId: store.id,
          rut: store.rut,
          legalName: store.legalName,
          businessLine: store.businessLine,
          taxConfig: store.taxConfig.toJson(),
        ),
        statusCode: 200,
      );
    } on NotFoundFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 404,
      );
    }
  }

  /// Para app: resolver id activo sin excepción.
  Future<StoreId?> activeStoreId() async {
    final store = await _stores.findActive();
    return store?.id;
  }

  StoreRepository get storeRepository => _stores;

  Future<ApiResult<PosTemplateResponse>> getPosTemplate(StoreId storeId) async {
    try {
      final template = await _getPosTemplate(storeId);
      final features =
          template.features.map((f) => f.apiValue).toList()..sort();
      return ApiSuccess(
        PosTemplateResponse(
          templateId: template.id.apiValue,
          displayName: template.displayName,
          features: features,
        ),
        statusCode: 200,
      );
    } on NotFoundFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message, details: e.details),
        statusCode: 404,
      );
    }
  }

  Future<ApiResult<StoreOperationalConfigResponse>>
      getStoreOperationalConfig(StoreId storeId) async {
    try {
      final result = await _getOperationalConfig(storeId);
      return ApiSuccess(
        _mapOperationalConfig(result),
        statusCode: 200,
      );
    } on NotFoundFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message, details: e.details),
        statusCode: 404,
      );
    }
  }

  Future<ApiResult<StoreOperationalConfigResponse>> patchStoreOperationalConfig(
    StoreId storeId,
    PatchStoreOperationalConfigRequest request,
  ) async {
    try {
      final result = await _updateOperationalConfig(
        UpdateStoreOperationalConfigInput(
          storeId: storeId,
          patch: _patchToOverrides(request),
        ),
      );
      return ApiSuccess(
        _mapOperationalConfig(result),
        statusCode: 200,
      );
    } on NotFoundFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message, details: e.details),
        statusCode: 404,
      );
    } on ForbiddenFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 403,
      );
    } on ValidationFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 400,
      );
    } on SessionExpiredFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 401,
      );
    }
  }

  StoreOperationalConfigResponse _mapOperationalConfig(
    StoreOperationalConfigResult result,
  ) {
    final features = result.effectiveTemplate.features
        .map((f) => f.apiValue)
        .toList()
      ..sort();
    final o = result.overrides;
    return StoreOperationalConfigResponse(
      schemaVersion: StoreOperationalOverrides.currentSchemaVersion,
      templateId: result.templateId.apiValue,
      overrides: StoreOperationalOverridesDto(
        sellerCodeRequired: o.sellerCodeRequired,
        invoiceCheckoutEnabled: o.invoiceCheckoutEnabled,
        transbankEnabled: o.transbankEnabled,
        receiptRequiresGuiaLote: o.receiptRequiresGuiaLote,
        trackExpiryOnReceipt: o.trackExpiryOnReceipt,
        inventoryCloseEnabled: o.inventoryCloseEnabled,
        dteEnabled: o.dteEnabled,
      ),
      effectiveFeatures: features,
    );
  }

  StoreOperationalOverrides _patchToOverrides(
    PatchStoreOperationalConfigRequest request,
  ) {
    return StoreOperationalOverrides(
      sellerCodeRequired: request.sellerCodeRequired,
      invoiceCheckoutEnabled: request.invoiceCheckoutEnabled,
      transbankEnabled: request.transbankEnabled,
      receiptRequiresGuiaLote: request.receiptRequiresGuiaLote,
      trackExpiryOnReceipt: request.trackExpiryOnReceipt,
      inventoryCloseEnabled: request.inventoryCloseEnabled,
      dteEnabled: request.dteEnabled,
    );
  }
}