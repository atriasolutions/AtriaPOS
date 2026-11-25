/// Evita enviar el mismo código de barras varias veces seguidas (lector/cámara).
class CompanionScanDedup {
  CompanionScanDedup({
    this.window = const Duration(milliseconds: 400),
  });

  final Duration window;

  String? _lastCode;
  DateTime? _lastAt;

  bool shouldAccept(String code, DateTime now) {
    if (_lastCode == code &&
        _lastAt != null &&
        now.difference(_lastAt!) < window) {
      return false;
    }
    _lastCode = code;
    _lastAt = now;
    return true;
  }
}