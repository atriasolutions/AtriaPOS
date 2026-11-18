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
  }) {
    final stores = storeRepository ?? InMemoryStoreRepository();
    final users = userRepository ?? InMemoryUserRepository();
    final hasher = pinHasher ?? BcryptPinHasher();
    final sessions = sessionProvider ?? InMemorySessionProvider();
    return StoreService._(stores, users, hasher, sessions);
  }

  StoreService._(
    StoreRepository stores,
    UserRepository users,
    PinHasher hasher,
    SessionProvider sessions,
  )   : _bootstrap = BootstrapStore(stores, users, hasher, sessions),
        _getActive = GetActiveStore(stores),
        _stores = stores;

  final BootstrapStore _bootstrap;
  final GetActiveStore _getActive;
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
          ownerDisplayName: request.ownerDisplayName,
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
}