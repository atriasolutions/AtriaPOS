import '../domain/domain.dart';
import 'auth_helpers.dart';
import 'ports/scan_session_repository.dart';
import 'ports/session_provider.dart';

class CancelScanSession {
  CancelScanSession(this._sessions, this._sessionProvider);

  final ScanSessionRepository _sessions;
  final SessionProvider _sessionProvider;

  Future<ScanSession> call(StoreId storeId, ScanSessionId sessionId) async {
    final session = requireActiveSession(_sessionProvider);
    AuthPolicy.require(session, Permission.ajustarInventario);

    final scan = await _sessions.findById(storeId, sessionId);
    if (scan == null) {
      throw NotFoundFailure(
        'Sesión de escaneo no encontrada',
        details: {'sessionId': sessionId},
      );
    }
    if (!scan.isDraft) {
      throw const ValidationFailure('La sesión ya fue cerrada');
    }

    final cancelled = scan.copyWith(state: ScanSessionState.cancelled);
    await _sessions.save(cancelled);
    return cancelled;
  }
}