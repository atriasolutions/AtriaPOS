import '../domain/domain.dart';
import 'ports/companion_live_sessions.dart';
import 'ports/companion_pairing_repository.dart';

class GetCompanionLanStatus {
  GetCompanionLanStatus(this._repo, this._live);

  final CompanionPairingRepository _repo;
  final CompanionLiveSessions _live;

  Future<CompanionLanStatus> call(StoreId storeId) async {
    final session = await _repo.activeSession(storeId);
    if (session == null || session.isExpired) {
      return CompanionLanStatus(
        storeId: storeId,
        phase: CompanionLanPhase.none,
      );
    }
    final phase = _live.isLive(session.token)
        ? CompanionLanPhase.live
        : CompanionLanPhase.sessionOnly;
    return CompanionLanStatus(
      storeId: storeId,
      phase: phase,
      mode: session.mode,
    );
  }
}