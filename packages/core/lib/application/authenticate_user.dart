import '../domain/domain.dart';
import 'ports/pin_hasher.dart';
import 'ports/session_provider.dart';
import 'ports/user_repository.dart';

class AuthenticateUser {
  AuthenticateUser(
    this._users,
    this._hasher,
    this._sessions, {
    this.sessionTtl = const Duration(minutes: 15),
  });

  final UserRepository _users;
  final PinHasher _hasher;
  final SessionProvider _sessions;
  final Duration sessionTtl;

  Future<AuthSession> call(StoreId storeId, UserId userId, String pin) async {
    final user = await _users.findById(storeId, userId);
    if (user == null || !_hasher.verify(pin, user.pinHash)) {
      throw const CredentialFailure('Usuario o PIN incorrectos');
    }
    final session = AuthSession(
      userId: user.id,
      role: user.role,
      expiresAt: DateTime.now().toUtc().add(sessionTtl),
    );
    _sessions.setSession(session);
    return session;
  }
}