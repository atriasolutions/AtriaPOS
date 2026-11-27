import 'failures.dart';

/// Normaliza y valida referencia de guía o lote en ingreso (sin ñ).
class StockReceiptRefPolicy {
  static final _pattern = RegExp(r'^[A-Z0-9_-]{1,32}$');

  static String normalize(String raw) {
    validate(raw);
    return raw.trim().toUpperCase();
  }

  static String normalizeOptional(String raw, {required bool required}) {
    final value = raw.trim();
    if (value.isEmpty) {
      if (required) {
        throw const ValidationFailure('Ingrese la referencia de guía o lote');
      }
      return '';
    }
    validate(value);
    return value.toUpperCase();
  }

  static void validate(String raw) {
    final value = raw.trim();
    if (value.isEmpty) {
      throw const ValidationFailure('Ingrese la referencia de guía o lote');
    }
    if (value.contains('ñ') || value.contains('Ñ')) {
      throw const ValidationFailure(
        'La referencia no puede contener la letra ñ',
      );
    }
    final upper = value.toUpperCase();
    if (!_pattern.hasMatch(upper)) {
      throw const ValidationFailure(
        'La referencia debe tener 1 a 32 caracteres (letras, números, - o _)',
      );
    }
  }
}