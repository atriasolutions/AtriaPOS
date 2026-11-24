import 'failures.dart';

/// DEC-047: username y PIN sin letra ñ (username se normaliza al ingresar).
class CredentialPolicy {
  /// Sustituye ñ/Ñ por n/N (SLICE-78).
  static String normalizeUsername(String raw) {
    return raw.trim().replaceAll('ñ', 'n').replaceAll('Ñ', 'N');
  }

  static void validateUsername(String raw) {
    final value = normalizeUsername(raw);
    if (value.isEmpty) {
      throw const ValidationFailure('Ingrese un nombre de usuario');
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