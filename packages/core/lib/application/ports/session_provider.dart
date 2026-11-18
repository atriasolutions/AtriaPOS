import '../../domain/domain.dart';

abstract class SessionProvider {
  AuthSession? get current;

  void setSession(AuthSession session);

  void clear();
}