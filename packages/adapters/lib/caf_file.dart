import 'dart:io';

import 'package:xml/xml.dart';

/// Rango CAF SII leído desde archivo XML local.
class CafRange {
  const CafRange({
    required this.documentType,
    required this.desde,
    required this.hasta,
  });

  final int documentType;
  final int desde;
  final int hasta;
}

class CafFile {
  CafFile._();

  static CafRange? parseXml(String xmlContent) {
    try {
      final doc = XmlDocument.parse(xmlContent);
      final td = doc.findAllElements('TD').firstOrNull;
      final d = doc.findAllElements('D').firstOrNull;
      final h = doc.findAllElements('H').firstOrNull;
      if (td == null || d == null || h == null) return null;
      return CafRange(
        documentType: int.parse(td.innerText.trim()),
        desde: int.parse(d.innerText.trim()),
        hasta: int.parse(h.innerText.trim()),
      );
    } catch (_) {
      return null;
    }
  }

  static Future<CafRange?> loadFromPath(String? path) async {
    if (path == null || path.isEmpty) return null;
    final file = File(path);
    if (!await file.exists()) return null;
    return parseXml(await file.readAsString());
  }

  static Future<CafRange?> loadFromEnvironment() {
    const path = String.fromEnvironment('SII_CAF_PATH');
    return loadFromPath(path.isEmpty ? null : path);
  }
}