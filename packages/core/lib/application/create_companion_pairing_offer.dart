import '../domain/domain.dart';
import 'companion_pairing_code.dart';
import 'ports/companion_pairing_repository.dart';
import 'ports/trusted_clock.dart';

class CreateCompanionPairingOfferInput {
  const CreateCompanionPairingOfferInput({
    required this.storeId,
    required this.mode,
  });

  final StoreId storeId;
  final CompanionMode mode;
}

class CreateCompanionPairingOfferResult {
  const CreateCompanionPairingOfferResult({
    required this.pairingCode,
    required this.mode,
    required this.expiresAt,
  });

  final String pairingCode;
  final CompanionMode mode;
  final DateTime expiresAt;
}

class CreateCompanionPairingOffer {
  CreateCompanionPairingOffer(
    this._repo, [
    TrustedClock? clock,
  ]) : _clock = clock ?? MutableTrustedClock();

  final CompanionPairingRepository _repo;
  final TrustedClock _clock;

  Future<CreateCompanionPairingOfferResult> call(
    CreateCompanionPairingOfferInput input,
  ) async {
    final now = _clock.now().toUtc();
    final expiresAt = now.add(CompanionLanConstants.offerTtl);
    final code = CompanionPairingCode.generate(
      length: CompanionLanConstants.pairingCodeLength,
    );
    final offer = CompanionPairingOffer(
      storeId: input.storeId,
      pairingCode: code,
      mode: input.mode,
      expiresAt: expiresAt,
      createdAt: now,
    );
    await _repo.saveOffer(offer);
    return CreateCompanionPairingOfferResult(
      pairingCode: code,
      mode: input.mode,
      expiresAt: expiresAt,
    );
  }
}