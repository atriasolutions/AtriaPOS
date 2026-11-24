import 'dart:io';

import 'package:path/path.dart' as p;

/// Archivo SQLite legado (piloto pre SLICE-56).
const String kLegacySqliteFileName = 'pos_barrio.sqlite';

/// Archivo SQLite instalaciones nuevas.
const String kCanonicalSqliteFileName = 'atria_pos.sqlite';

/// Usa BD legada si existe; si no, ruta canónica (DEC-044).
String resolveSqlitePath(String directoryPath) {
  final legacy = File(p.join(directoryPath, kLegacySqliteFileName));
  if (legacy.existsSync()) {
    return legacy.path;
  }
  return p.join(directoryPath, kCanonicalSqliteFileName);
}