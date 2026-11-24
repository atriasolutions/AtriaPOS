import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  group('CredentialPolicy', () {
    test('SC-080-02 username con ñ rechazado', () {
      expect(
        () => CredentialPolicy.validateUsername('cañero'),
        throwsA(isA<ValidationFailure>()),
      );
    });

    test('username válido', () {
      expect(() => CredentialPolicy.validateUsername('cajero1'), returnsNormally);
    });

    test('SC-080-03 PIN con ñ rechazado', () {
      expect(
        () => CredentialPolicy.validatePin('12ñ4'),
        throwsA(isA<ValidationFailure>()),
      );
    });
  });
}