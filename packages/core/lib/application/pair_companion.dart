import '../domain/domain.dart';
import 'ports/companion_pairing_repository.dart';
import 'ports/trusted_clock.dart';

class PairCompanionInput {
  const PairCompanionInput({
    required this.storeId,
    required this.pairingCode,
    required this.mode,
  });

  final StoreId storeId;
  final String pairingCode;
  final CompanionMode mode;
}

class PairCompanionResult {
  const PairCompanionResult({
    required this.token,
    required this.expiresAt,
    required this.wsPath,
    required this.mode,
  });

  final String token;
  final DateTime expiresAt;
  final String wsPath;
  final CompanionMode mode;
}

class PairCompanion {
  PairCompanion(
    this._repo, [
    TrustedClock? clock,
  ]) : _clock = clock ?? MutableTrustedClock();

  final CompanionPairingRepository _repo;
  final TrustedClock _clock;
  var _tokenSeq = 0;

  Future<PairCompanionResult> call(PairCompanionInput input) async {
    final offer = await _repo.findOffer(input.storeId, input.pairingCode);
    if (offer == null || offer.isExpired || !offer.matchesCode(input.pairingCode)) {
      throw const ValidationFailure('Código de emparejamiento inválido o expirado');
    }
    if (offer.mode != input.mode) {
      throw const ValidationFailure('El modo no coincide con el código QR');
    }
    await _repo.clearActiveSession(input.storeId);
    final now = _clock.now().toUtc();
    _tokenSeq++;
    final token = 'ctok_${input.storeId}_$_tokenSeq';
    final session = CompanionActiveSession(
      token: token,
      storeId: input.storeId,
      mode: input.mode,
      expiresAt: now.add(CompanionLanConstants.sessionTtl),
      createdAt: now,
    );
    await _repo.saveActiveSession(session);
    return PairCompanionResult(
      token: token,
      expiresAt: session.expiresAt,
      wsPath: CompanionLanConstants.wsPath,
      mode: session.mode,
    );
  }
}