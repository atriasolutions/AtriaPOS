import 'package:adapters/adapters.dart';
import 'package:core/atria_pos_core.dart';
import 'package:drift/native.dart';
import 'package:test/test.dart';

void main() {
  late AppDatabase db;
  late DriftStoreRepository stores;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    stores = DriftStoreRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('SC-089-06 persiste y lee pos_template_id', () async {
    final store = Store.create(
      id: 'store_01',
      rutRaw: '12.345.678-5',
      legalName: 'Minimarket',
      businessLine: 'Almacén',
    );
    await stores.save(store);
    final loaded = await stores.findById('store_01');
    expect(loaded?.posTemplateId, PosTemplateId.atriaPos);
  });

  test('SC-089-07 valor desconocido en BD → Atria al leer', () async {
    final store = Store(
      id: 'store_02',
      rut: '12.345.678-5',
      legalName: 'X',
      businessLine: 'Y',
      taxConfig: const TaxConfig(),
      createdAt: DateTime.now().toUtc(),
      posTemplateId: PosTemplateId.atriaPos,
    );
    await stores.save(store);
    await db.customStatement(
      "UPDATE stores SET pos_template_id = 'LEGACY_UNKNOWN' WHERE id = 'store_02'",
    );
    final loaded = await stores.findById('store_02');
    expect(loaded?.posTemplateId, PosTemplateId.atriaPos);
  });
}