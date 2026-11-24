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
    ShiftRepository? shiftRepository,
  }) {
    final users = userRepository ?? InMemoryUserRepository();
    final hasher = pinHasher ?? BcryptPinHasher();
    final sessions = sessionProvider ?? InMemorySessionProvider();
    final shifts = shiftRepository ?? InMemoryShiftRepository();
    return AuthService._(users, hasher, sessions, shifts);
  }

  AuthService._(
    UserRepository users,
    PinHasher hasher,
    SessionProvider sessions,
    ShiftRepository shifts,
  )   : _authenticate = AuthenticateUser(users, hasher, sessions),
        _createUser = CreateUser(users, hasher, sessions),
        _listUsers = ListUsers(users, sessions),
        _updateUser = UpdateUser(users, hasher, sessions),
        _endSession = EndSession(sessions, shifts),
        _sessions = sessions,
        _users = users;

  final AuthenticateUser _authenticate;
  final CreateUser _createUser;
  final ListUsers _listUsers;
  final UpdateUser _updateUser;
  final EndSession _endSession;
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

  Future<ApiResult<List<UserProfileResponse>>> listUsers(StoreId storeId) async {
    try {
      final users = await _listUsers(storeId);
      final data = users
          .map(
            (user) => UserProfileResponse(
              id: user.id,
              username: user.username,
              firstName: user.firstName,
              lastName: user.lastName,
              rut: user.rut,
              role: user.role.apiValue,
              displayName: user.displayName,
            ),
          )
          .toList();
      return ApiSuccess(data, statusCode: 200);
    } on ForbiddenFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 403,
      );
    } on SessionExpiredFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 401,
      );
    }
  }

  Future<ApiResult<UserProfileResponse>> updateUser(
    StoreId storeId,
    UserId userId,
    UpdateUserRequest request,
  ) async {
    try {
      final user = await _updateUser(
        UpdateUserInput(
          storeId: storeId,
          userId: userId,
          firstName: request.firstName,
          lastName: request.lastName,
          rut: request.rut,
          role: UserRole.fromApi(request.role),
          newPin: request.newPin,
        ),
      );
      return ApiSuccess(
        UserProfileResponse(
          id: user.id,
          username: user.username,
          firstName: user.firstName,
          lastName: user.lastName,
          rut: user.rut,
          role: user.role.apiValue,
          displayName: user.displayName,
        ),
        statusCode: 200,
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
    } on NotFoundFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message, details: e.details),
        statusCode: 404,
      );
    } on SessionExpiredFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 401,
      );
    }
  }

  Future<ApiResult<void>> endSession(StoreId storeId) async {
    try {
      await _endSession(storeId);
      return ApiSuccess(null, statusCode: 204);
    } on ValidationFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 400,
      );
    } on CredentialFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 401,
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