import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';
  late InMemoryCompanionPairingRepository repo;
  late CreateCompanionPairingOffer createOffer;
  late ResolveCompanionShortLink resolve;

  setUp(() {
    repo = InMemoryCompanionPairingRepository();
    createOffer = CreateCompanionPairingOffer(repo);
    resolve = ResolveCompanionShortLink(repo);
  });

  test('SC-107-01 resuelve oferta por código', () async {
    final offer = await createOffer(
      const CreateCompanionPairingOfferInput(
        storeId: storeId,
        mode: CompanionMode.vender,
      ),
    );
    final resolved = await resolve(offer.pairingCode);
    expect(resolved, isNotNull);
    expect(resolved!.storeId, storeId);
    expect(resolved.mode, CompanionMode.vender);
    expect(resolved.pairingCode, offer.pairingCode);
  });

  test('SC-107-02 código inexistente retorna null', () async {
    expect(await resolve('ZZZZZZ'), isNull);
  });

  test('SC-107-02b oferta expirada retorna null', () async {
    final clock = MutableTrustedClock();
    createOffer = CreateCompanionPairingOffer(repo, clock);
    resolve = ResolveCompanionShortLink(repo, clock);
    final offer = await createOffer(
      const CreateCompanionPairingOfferInput(
        storeId: storeId,
        mode: CompanionMode.vender,
      ),
    );
    clock.updateFromSync(
      newOffset: const Duration(minutes: 31),
      newSource: TrustedClockSource.device,
      syncedAt: clock.now(),
    );
    expect(await resolve(offer.pairingCode), isNull);
  });

  test('SC-107-05 URL corta sin query', () {
    final url = buildCompanionShortLinkUrl(
      base: Uri.parse('http://192.168.1.1:8765'),
      pairingCode: 'A7K9M2',
    );
    expect(url, 'http://192.168.1.1:8765/c/A7K9M2');
    expect(url.contains('storeId'), isFalse);
  });
}