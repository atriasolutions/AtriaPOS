class LoginRequest {
  const LoginRequest({
    required this.username,
    required this.pin,
  });

  final String username;
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
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.rut,
    required this.role,
    required this.pin,
  });

  final String username;
  final String firstName;
  final String lastName;
  final String rut;
  final String role;
  final String pin;
}

class CreateUserResponse {
  const CreateUserResponse({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.rut,
    required this.role,
    required this.displayName,
  });

  final String id;
  final String username;
  final String firstName;
  final String lastName;
  final String rut;
  final String role;
  final String displayName;
}