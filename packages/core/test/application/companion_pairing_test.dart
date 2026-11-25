import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';
  late InMemoryCompanionPairingRepository repo;
  late CreateCompanionPairingOffer createOffer;
  late PairCompanion pair;
  late CompanionSubmitScan submitScan;

  setUp(() {
    repo = InMemoryCompanionPairingRepository();
    createOffer = CreateCompanionPairingOffer(repo);
    pair = PairCompanion(repo);
    submitScan = CompanionSubmitScan(repo);
  });

  test('SC-096-01 oferta y emparejamiento válido', () async {
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
    expect(paired.token, startsWith('ctok_'));
    expect(paired.wsPath, CompanionLanConstants.wsPath);
  });

  test('SC-096-02 modo distinto → VALIDACION', () async {
    final offer = await createOffer(
      const CreateCompanionPairingOfferInput(
        storeId: storeId,
        mode: CompanionMode.vender,
      ),
    );
    expect(
      () => pair(
        PairCompanionInput(
          storeId: storeId,
          pairingCode: offer.pairingCode,
          mode: CompanionMode.receiptScan,
        ),
      ),
      throwsA(isA<ValidationFailure>()),
    );
  });

  test('SC-096-03 nuevo pair revoca sesión anterior', () async {
    final offer1 = await createOffer(
      const CreateCompanionPairingOfferInput(
        storeId: storeId,
        mode: CompanionMode.vender,
      ),
    );
    final first = await pair(
      PairCompanionInput(
        storeId: storeId,
        pairingCode: offer1.pairingCode,
        mode: CompanionMode.vender,
      ),
    );
    final offer2 = await createOffer(
      const CreateCompanionPairingOfferInput(
        storeId: storeId,
        mode: CompanionMode.vender,
      ),
    );
    final second = await pair(
      PairCompanionInput(
        storeId: storeId,
        pairingCode: offer2.pairingCode,
        mode: CompanionMode.vender,
      ),
    );
    expect(first.token, isNot(second.token));
    expect(await repo.findByToken(first.token), isNull);
    expect(await repo.findByToken(second.token), isNotNull);
  });

  test('SC-096-04 submit scan con token válido', () async {
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
    final scan = await submitScan(
      CompanionSubmitScanInput(token: paired.token, rawCode: '12345678'),
    );
    expect(scan?.code, '12345678');
    expect(scan?.mode, CompanionMode.vender);
  });
}