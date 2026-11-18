class LoginRequest {
  const LoginRequest({
    required this.userId,
    required this.pin,
  });

  final String userId;
  final String pin;
}

class LoginResponse {
  const LoginResponse({
    required this.token,
    required this.role,
    required this.expiresAt,
  });

  final String token;
  final String role;
  final String expiresAt;
}

class CreateUserRequest {
  const CreateUserRequest({
    required this.userId,
    required this.displayName,
    required this.role,
    required this.pin,
  });

  final String userId;
  final String displayName;
  final String role;
  final String pin;
}

class CreateUserResponse {
  const CreateUserResponse({
    required this.userId,
    required this.role,
    required this.displayName,
  });

  final String userId;
  final String role;
  final String displayName;
}