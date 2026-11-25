import '../domain/domain.dart';
import 'ports/companion_live_sessions.dart';
import 'ports/companion_pairing_repository.dart';

class DisconnectCompanionLan {
  DisconnectCompanionLan(this._repo, this._live);

  final CompanionPairingRepository _repo;
  final CompanionLiveSessions _live;

  Future<void> call(StoreId storeId) async {
    final session = await _repo.activeSession(storeId);
    if (session == null) return;
    await _live.disconnect(session.token);
    await _repo.clearActiveSession(storeId);
  }
}