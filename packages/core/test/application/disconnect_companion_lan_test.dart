import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

class _FakeLiveSessions implements CompanionLiveSessions {
  final Set<String> live = {};
  final List<String> disconnected = [];

  @override
  Future<void> disconnect(String token) async {
    disconnected.add(token);
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
  late DisconnectCompanionLan disconnect;
  late GetCompanionLanStatus getStatus;

  setUp(() {
    repo = InMemoryCompanionPairingRepository();
    createOffer = CreateCompanionPairingOffer(repo);
    pair = PairCompanion(repo);
    live = _FakeLiveSessions();
    disconnect = DisconnectCompanionLan(repo, live);
    getStatus = GetCompanionLanStatus(repo, live);
  });

  test('SC-111-04 disconnect limpia sesión y WS', () async {
    final offer = await createOffer(
      const CreateCompanionPairingOfferInput(
        storeId: storeId,
        mode: CompanionMode.vender,
      ),
    );
    final paired = await pair(
      PairCompanionInput(
        storeId: storeId,
        pairingCode: offer.pairingCode,
        mode: CompanionMode.vender,
      ),
    );
    live.live.add(paired.token);

    await disconnect(storeId);

    expect(live.disconnected, [paired.token]);
    expect(await repo.activeSession(storeId), isNull);
    expect((await getStatus(storeId)).phase, CompanionLanPhase.none);
  });

  test('disconnect sin sesión es no-op', () async {
    await disconnect(storeId);
    expect(live.disconnected, isEmpty);
  });
}