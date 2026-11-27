import 'dart:convert';

abstract final class CompanionWsMessage {
  static Map<String, Object?>? decode(String raw) {
    try {
      final parsed = jsonDecode(raw);
      if (parsed is! Map<String, dynamic>) return null;
      return parsed;
    } catch (_) {
      return null;
    }
  }

  static String? scanCode(Map<String, Object?> message) {
    if (message['type'] != 'scan') return null;
    final code = message['code'];
    if (code is! String) return null;
    return code;
  }

  static bool isHeartbeat(Map<String, Object?> message) =>
      message['type'] == 'heartbeat';

  /// Respuesta del POS tras aceptar un escaneo (`accepted: true`).
  static bool isScanAccepted(Map<String, Object?> message) =>
      message['type'] == 'scan' && message['accepted'] == true;

  static String? scanAcceptedProductName(Map<String, Object?> message) {
    if (!isScanAccepted(message)) return null;
    final name = message['productName'];
    if (name is! String) return null;
    final trimmed = name.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  static String? scanAcceptedCode(Map<String, Object?> message) {
    if (!isScanAccepted(message)) return null;
    final code = message['code'];
    if (code is! String) return null;
    final trimmed = code.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}