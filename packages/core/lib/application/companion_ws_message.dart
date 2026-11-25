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
}