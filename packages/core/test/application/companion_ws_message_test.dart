import 'package:core/application/application.dart';
import 'package:test/test.dart';

void main() {
  test('SC-144-02 parsea productName en confirmación de scan', () {
    final message = <String, Object?>{
      'type': 'scan',
      'accepted': true,
      'code': '7801',
      'productName': '  Pan  ',
    };
    expect(CompanionWsMessage.isScanAccepted(message), isTrue);
    expect(CompanionWsMessage.scanAcceptedProductName(message), 'Pan');
    expect(CompanionWsMessage.scanAcceptedCode(message), '7801');
  });
}