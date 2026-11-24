import '../application/application.dart';
import '../domain/domain.dart';
import 'api_error.dart';
import 'api_result.dart';
import 'auth_dtos.dart';

class AuthService {
  factory AuthService({
    UserRepository? userRepository,
    PinHasher? pinHasher,
    SessionProvider? sessionProvider,
  }) {
    final users = userRepository ?? InMemoryUserRepository();
    final hasher = pinHasher ?? BcryptPinHasher();
    final sessions = sessionProvider ?? InMemorySessionProvider();
    return AuthService._(users, hasher, sessions);
  }

  AuthService._(UserRepository users, PinHasher hasher, SessionProvider sessions)
      : _authenticate = AuthenticateUser(users, hasher, sessions),
        _createUser = CreateUser(users, hasher, sessions),
        _sessions = sessions,
        _users = users;

  final AuthenticateUser _authenticate;
  final CreateUser _createUser;
  final SessionProvider _sessions;
  final UserRepository _users;

  SessionProvider get sessionProvider => _sessions;

  Future<ApiResult<LoginResponse>> login(
    StoreId storeId,
    LoginRequest request,
  ) async {
    try {
      final session =
          await _authenticate(storeId, request.username, request.pin);
      return ApiSuccess(
        LoginResponse(
          token: session.token,
          role: session.role.apiValue,
          expiresAt: session.expiresAt.toUtc().toIso8601String(),
        ),
        statusCode: 200,
      );
    } on CredentialFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 401,
      );
    }
  }

  Future<ApiResult<CreateUserResponse>> createUser(
    StoreId storeId,
    CreateUserRequest request,
  ) async {
    try {
      final user = await _createUser(
        CreateUserInput(
          storeId: storeId,
          username: request.username,
          firstName: request.firstName,
          lastName: request.lastName,
          rut: request.rut,
          role: UserRole.fromApi(request.role),
          pin: request.pin,
        ),
      );
      return ApiSuccess(
        CreateUserResponse(
          id: user.id,
          username: user.username,
          firstName: user.firstName,
          lastName: user.lastName,
          rut: user.rut,
          role: user.role.apiValue,
          displayName: user.displayName,
        ),
        statusCode: 201,
      );
    } on CredentialFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 401,
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
    } on ConflictFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message, details: e.details),
        statusCode: 409,
      );
    } on SessionExpiredFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 401,
      );
    }
  }

  /// Expuesto para tests y seeds.
  UserRepository get userRepository => _users;
}