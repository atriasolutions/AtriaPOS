import 'failures.dart';

/// Normaliza y valida código vendedor de planilla (sin ñ).
class SellerCodePolicy {
  static final _pattern = RegExp(r'^[A-Z0-9]{2,8}$');

  static String normalize(String raw) {
    validate(raw);
    return raw.trim().toUpperCase();
  }

  static void validate(String raw) {
    final value = raw.trim();
    if (value.isEmpty) {
      throw const ValidationFailure('Ingrese el código vendedor');
    }
    if (value.contains('ñ') || value.contains('Ñ')) {
      throw const ValidationFailure(
        'El código vendedor no puede contener la letra ñ',
      );
    }
    final upper = value.toUpperCase();
    if (!_pattern.hasMatch(upper)) {
      throw const ValidationFailure(
        'El código vendedor debe tener 2 a 8 caracteres (letras y números)',
      );
    }
  }
}