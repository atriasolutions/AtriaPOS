import 'failures.dart';
import 'user_role.dart';

typedef UserId = String;

class AuthSession {
  AuthSession({
    required this.userId,
    required this.role,
    required this.expiresAt,
    this.token = 'local-session',
  });

  final UserId userId;
  final UserRole role;
  final DateTime expiresAt;
  final String token;

  bool get isActive => DateTime.now().toUtc().isBefore(expiresAt);

  void requireActive() {
    if (!isActive) {
      throw const SessionExpiredFailure(
        'La sesión expiró. Vuelva a iniciar sesión.',
      );
    }
  }

  AuthSession renew({Duration ttl = const Duration(minutes: 15)}) =>
      AuthSession(
        userId: userId,
        role: role,
        expiresAt: DateTime.now().toUtc().add(ttl),
        token: token,
      );
}