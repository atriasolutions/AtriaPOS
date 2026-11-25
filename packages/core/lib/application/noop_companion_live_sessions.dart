import 'ports/companion_live_sessions.dart';

class NoopCompanionLiveSessions implements CompanionLiveSessions {
  const NoopCompanionLiveSessions();

  @override
  Future<void> disconnect(String token) async {}

  @override
  bool isLive(String token) => false;
}