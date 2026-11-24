import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  group('CredentialPolicy', () {
    test('SC-078-01 username con ñ se normaliza', () {
      expect(CredentialPolicy.normalizeUsername('cañero'), 'canero');
      expect(
        () => CredentialPolicy.validateUsername('cañero'),
        returnsNormally,
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