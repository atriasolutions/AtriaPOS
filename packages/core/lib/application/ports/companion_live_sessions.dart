/// Conexiones WebSocket companion abiertas (implementación en adapters).
abstract class CompanionLiveSessions {
  bool isLive(String token);

  Future<void> disconnect(String token);
}