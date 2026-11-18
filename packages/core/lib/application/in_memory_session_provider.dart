import '../domain/domain.dart';
import 'ports/session_provider.dart';

class InMemorySessionProvider implements SessionProvider {
  AuthSession? _current;

  InMemorySessionProvider({AuthSession? initial}) : _current = initial;

  /// Sesión supervisor para regresión en tests sin login explícito.
  factory InMemorySessionProvider.supervisor({
    UserId userId = 'usr_supervisor',
  }) {
    return InMemorySessionProvider(
      initial: AuthSession(
        userId: userId,
        role: UserRole.supervisor,
        expiresAt: DateTime.now().toUtc().add(const Duration(hours: 8)),
      ),
    );
  }

  @override
  AuthSession? get current => _current;

  @override
  void setSession(AuthSession session) {
    _current = session;
  }

  @override
  void clear() {
    _current = null;
  }

  AuthSession requireSession() {
    final session = _current;
    if (session == null) {
      throw const CredentialFailure('Debe iniciar sesión');
    }
    session.requireActive();
    return session;
  }
}