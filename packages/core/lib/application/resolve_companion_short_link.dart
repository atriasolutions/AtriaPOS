import '../domain/domain.dart';
import 'ports/companion_pairing_repository.dart';
import 'ports/trusted_clock.dart';

class CompanionShortLinkTarget {
  const CompanionShortLinkTarget({
    required this.storeId,
    required this.mode,
    required this.pairingCode,
  });

  final StoreId storeId;
  final CompanionMode mode;
  final String pairingCode;
}

class ResolveCompanionShortLink {
  ResolveCompanionShortLink(
    this._repo, [
    TrustedClock? clock,
  ]) : _clock = clock ?? MutableTrustedClock();

  final CompanionPairingRepository _repo;
  final TrustedClock _clock;

  Future<CompanionShortLinkTarget?> call(String rawCode) async {
    final offer = await _repo.findOfferByPairingCode(rawCode);
    if (offer == null) return null;
    final now = _clock.now().toUtc();
    if (!now.isBefore(offer.expiresAt)) return null;
    return CompanionShortLinkTarget(
      storeId: offer.storeId,
      mode: offer.mode,
      pairingCode: offer.pairingCode,
    );
  }
}