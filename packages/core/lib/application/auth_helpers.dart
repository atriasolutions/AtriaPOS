import '../domain/domain.dart';
import 'ports/session_provider.dart';

AuthSession requireActiveSession(SessionProvider sessions) {
  final session = sessions.current;
  if (session == null) {
    throw const CredentialFailure('Debe iniciar sesión');
  }
  session.requireActive();
  return session;
}