import 'dart:convert';

import 'scanner_ble_constants.dart';

/// Codifica texto escaneado para envío BLE (UTF-8).
List<int> encodeScanPayload(String raw) {
  final decoded = decodeScanPayload(raw);
  if (decoded == null) return const [];
  return utf8.encode(decoded);
}

/// Decodifica bytes o string; null si vacío o excede límite.
String? decodeScanPayload(Object? raw) {
  final String text;
  if (raw is List<int>) {
    if (raw.isEmpty) return null;
    text = utf8.decode(raw, allowMalformed: true);
  } else if (raw is String) {
    text = raw;
  } else {
    return null;
  }
  final trimmed = text.trim();
  if (trimmed.isEmpty) return null;
  final bytes = utf8.encode(trimmed);
  if (bytes.length > ScannerBleConstants.maxPayloadBytes) return null;
  return trimmed;
}