/// Validación y formato RUT chileno (módulo 11).
class RutChile {
  /// Normaliza a `cuerpo-DV` sin puntos, DV en mayúscula.
  static String normalize(String raw) {
    final cleaned = raw
        .trim()
        .replaceAll('.', '')
        .replaceAll('-', '')
        .replaceAll(' ', '')
        .toUpperCase();
    if (cleaned.length < 2) return cleaned;
    final body = cleaned.substring(0, cleaned.length - 1);
    final dv = cleaned.substring(cleaned.length - 1);
    return '$body-$dv';
  }

  static String formatDisplay(String normalized) {
    final n = normalize(normalized);
    final parts = n.split('-');
    if (parts.length != 2) return normalized;
    final body = parts[0];
    final dv = parts[1];
    final buffer = StringBuffer();
    for (var i = 0; i < body.length; i++) {
      if (i > 0 && (body.length - i) % 3 == 0) buffer.write('.');
      buffer.write(body[i]);
    }
    return '${buffer.toString()}-$dv';
  }

  static bool isValid(String raw) {
    final normalized = normalize(raw);
    final parts = normalized.split('-');
    if (parts.length != 2) return false;
    final body = parts[0];
    final dv = parts[1];
    if (!RegExp(r'^\d+$').hasMatch(body)) return false;
    if (body.length < 7 || body.length > 8) return false;
    if (!RegExp(r'^[\dK]$').hasMatch(dv)) return false;
    return _computeDv(body) == dv;
  }

  static String _computeDv(String body) {
    var sum = 0;
    var multiplier = 2;
    for (var i = body.length - 1; i >= 0; i--) {
      sum += int.parse(body[i]) * multiplier;
      multiplier = multiplier == 7 ? 2 : multiplier + 1;
    }
    final mod = sum % 11;
    final result = 11 - mod;
    return switch (result) {
      11 => '0',
      10 => 'K',
      _ => result.toString(),
    };
  }
}