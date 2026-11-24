import 'failures.dart';

/// DEC-047: username y PIN sin letra ñ.
class CredentialPolicy {
  static void validateUsername(String raw) {
    final value = raw.trim();
    if (value.isEmpty) {
      throw const ValidationFailure('Ingrese un nombre de usuario');
    }
    if (value.contains('ñ') || value.contains('Ñ')) {
      throw const ValidationFailure(
        'El nombre de usuario no puede contener la letra ñ',
      );
    }
    if (!RegExp(r'^[a-zA-Z0-9._-]+$').hasMatch(value)) {
      throw const ValidationFailure(
        'El nombre de usuario solo puede usar letras, números, punto, guion y guion bajo',
      );
    }
  }

  static void validatePin(String pin) {
    if (pin.contains('ñ') || pin.contains('Ñ')) {
      throw const ValidationFailure('El PIN no puede contener la letra ñ');
    }
  }
}