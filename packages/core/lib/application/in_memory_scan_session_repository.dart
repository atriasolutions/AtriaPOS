import '../domain/domain.dart';
import 'ports/scan_session_repository.dart';

class InMemoryScanSessionRepository implements ScanSessionRepository {
  final _sessions = <String, ScanSession>{};

  @override
  Future<ScanSession?> findById(StoreId storeId, ScanSessionId sessionId) async {
    final session = _sessions[sessionId];
    if (session == null || session.storeId != storeId) return null;
    return session;
  }

  @override
  Future<void> save(ScanSession session) async {
    _sessions[session.id] = session;
  }
}