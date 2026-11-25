import 'package:core/api/api.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';
  late CompanionService service;

  setUp(() {
    service = CompanionService();
  });

  test('SC-096-05 API pair 200', () async {
    final offer = await service.createPairingOffer(
      storeId,
      CompanionMode.vender,
    );
    final code = (offer as ApiSuccess<CreateCompanionPairingOfferResponse>).data
        .pairingCode;
    final pair = await service.pair(
      storeId,
      CompanionPairRequest(pairingCode: code, mode: 'VENDER'),
    );
    expect(pair, isA<ApiSuccess<CompanionPairResponse>>());
  });
}