import '../../domain/domain.dart';

abstract class CompanionPairingRepository {
  Future<void> saveOffer(CompanionPairingOffer offer);

  Future<CompanionPairingOffer?> findOffer(StoreId storeId, String pairingCode);

  Future<CompanionActiveSession?> activeSession(StoreId storeId);

  Future<void> saveActiveSession(CompanionActiveSession session);

  Future<void> clearActiveSession(StoreId storeId);

  Future<CompanionActiveSession?> findByToken(String token);
}