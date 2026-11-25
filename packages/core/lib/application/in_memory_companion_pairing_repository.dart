import '../domain/domain.dart';
import 'ports/companion_pairing_repository.dart';

class InMemoryCompanionPairingRepository implements CompanionPairingRepository {
  final _offers = <String, CompanionPairingOffer>{};
  final _byStore = <StoreId, CompanionActiveSession>{};
  final _byToken = <String, CompanionActiveSession>{};

  String _offerKey(StoreId storeId, String code) =>
      '$storeId::${code.toUpperCase()}';

  @override
  Future<void> saveOffer(CompanionPairingOffer offer) async {
    _offers[_offerKey(offer.storeId, offer.pairingCode)] = offer;
  }

  @override
  Future<CompanionPairingOffer?> findOffer(
    StoreId storeId,
    String pairingCode,
  ) async =>
      _offers[_offerKey(storeId, pairingCode)];

  @override
  Future<CompanionActiveSession?> activeSession(StoreId storeId) async =>
      _byStore[storeId];

  @override
  Future<void> saveActiveSession(CompanionActiveSession session) async {
    _byStore[session.storeId] = session;
    _byToken[session.token] = session;
  }

  @override
  Future<void> clearActiveSession(StoreId storeId) async {
    final current = _byStore.remove(storeId);
    if (current != null) {
      _byToken.remove(current.token);
    }
  }

  @override
  Future<CompanionActiveSession?> findByToken(String token) async =>
      _byToken[token];
}