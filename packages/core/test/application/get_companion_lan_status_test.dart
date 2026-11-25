import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

class _FakeLiveSessions implements CompanionLiveSessions {
  final Set<String> live = {};

  @override
  Future<void> disconnect(String token) async {
    live.remove(token);
  }

  @override
  bool isLive(String token) => live.contains(token);
}

void main() {
  const storeId = 't1';
  late InMemoryCompanionPairingRepository repo;
  late CreateCompanionPairingOffer createOffer;
  late PairCompanion pair;
  late _FakeLiveSessions live;
  late GetCompanionLanStatus getStatus;

  setUp(() {
    repo = InMemoryCompanionPairingRepository();
    createOffer = CreateCompanionPairingOffer(repo);
    pair = PairCompanion(repo);
    live = _FakeLiveSessions();
    getStatus = GetCompanionLanStatus(repo, live);
  });

  test('SC-111-01 sin sesión → none', () async {
    final status = await getStatus(storeId);
    expect(status.phase, CompanionLanPhase.none);
    expect(status.mode, isNull);
  });

  test('SC-111-02 tras pair sin WS → sessionOnly', () async {
    final offer = await createOffer(
      const CreateCompanionPairingOfferInput(
        storeId: storeId,
        mode: CompanionMode.vender,
      ),
    );
    await pair(
      PairCompanionInput(
        storeId: storeId,
        pairingCode: offer.pairingCode,
        mode: CompanionMode.vender,
      ),
    );
    final status = await getStatus(storeId);
    expect(status.phase, CompanionLanPhase.sessionOnly);
    expect(status.mode, CompanionMode.vender);
  });

  test('SC-111-02b con WS vivo → live', () async {
    final offer = await createOffer(
      const CreateCompanionPairingOfferInput(
        storeId: storeId,
        mode: CompanionMode.receiptScan,
      ),
    );
    final paired = await pair(
      PairCompanionInput(
        storeId: storeId,
        pairingCode: offer.pairingCode,
        mode: CompanionMode.receiptScan,
      ),
    );
    live.live.add(paired.token);
    final status = await getStatus(storeId);
    expect(status.phase, CompanionLanPhase.live);
    expect(status.mode, CompanionMode.receiptScan);
  });
}