import 'dart:io';

import 'package:adapters/adapters.dart';
import 'package:drift/native.dart';
import 'package:test/test.dart';

void main() {
  test('CAF parsea rango tipo 39', () {
    final xml = File('test/fixtures/caf/boleta39.xml').readAsStringSync();
    final range = CafFile.parseXml(xml);
    expect(range, isNotNull);
    expect(range!.documentType, 39);
    expect(range.desde, 9001);
    expect(range.hasta, 9005);
  });

  test('InMemoryFolioAllocator entrega folios consecutivos', () async {
    final allocator = InMemoryFolioAllocator(
      range: const CafRange(documentType: 39, desde: 10, hasta: 12),
      initialNext: 10,
    );
    expect(await allocator.allocateNext('t1', 39), 10);
    expect(await allocator.allocateNext('t1', 39), 11);
    expect(await allocator.allocateNext('t1', 39), 12);
    expect(
      () => allocator.allocateNext('t1', 39),
      throwsA(isA<FolioAgotadoException>()),
    );
  });

  test('DriftFolioAllocator persiste siguiente folio', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(() async => db.close());
    final xml = File('test/fixtures/caf/boleta39.xml').readAsStringSync();
    final range = CafFile.parseXml(xml)!;
    final allocator = DriftFolioAllocator(
      db,
      loadCaf: () async => range,
    );
    expect(await allocator.allocateNext('t1', 39), 9001);
    expect(await allocator.allocateNext('t1', 39), 9002);
    final row = await (db.select(db.dteFolioCounters)
          ..where((t) => t.storeId.equals('t1')))
        .getSingle();
    expect(row.nextFolio, 9003);
  });
}