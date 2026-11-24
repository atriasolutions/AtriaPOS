import 'dart:io';

import 'package:core/app_database_paths.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  test('SLICE-56 prefiere pos_barrio.sqlite si existe', () {
    final dir = Directory.systemTemp.createTempSync('atria_db_test_');
    final legacyPath = p.join(dir.path, kLegacySqliteFileName);
    File(legacyPath).writeAsStringSync('');
    addTearDown(() => dir.deleteSync(recursive: true));

    expect(resolveSqlitePath(dir.path), legacyPath);
  });

  test('SLICE-56 usa atria_pos.sqlite en instalación nueva', () {
    final dir = Directory.systemTemp.createTempSync('atria_db_test_');
    addTearDown(() => dir.deleteSync(recursive: true));

    expect(
      resolveSqlitePath(dir.path),
      p.join(dir.path, kCanonicalSqliteFileName),
    );
  });
}