import 'companion_scan_dedup.dart';

/// Buffer de un código visto; el envío ocurre solo con [trigger].
class CompanionArmedScan {
  CompanionArmedScan({CompanionScanDedup? dedup})
      : _dedup = dedup ?? CompanionScanDedup();

  final CompanionScanDedup _dedup;
  String? _pending;

  String? get pending => _pending;

  /// Guarda el código; no envía. False si vacío o jitter del visor.
  bool onDetect(String raw, DateTime now) {
    final code = raw.trim();
    if (code.isEmpty) return false;
    if (!_dedup.shouldAccept(code, now)) return false;
    _pending = code;
    return true;
  }

  /// Código a enviar, o null. Vacía el buffer.
  String? trigger() {
    final code = _pending;
    _pending = null;
    return code;
  }
}
