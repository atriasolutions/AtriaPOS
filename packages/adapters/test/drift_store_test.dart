import 'package:adapters/adapters.dart';
import 'package:core/pos_barrio_core.dart';
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

  test('persiste tienda en drift', () async {
    final store = Store.create(
      id: 'store_01',
      rutRaw: '12.345.678-5',
      legalName: 'Minimarket',
      businessLine: 'Almacén',
    );
    await stores.save(store);
    final loaded = await stores.findById('store_01');
    expect(loaded?.legalName, 'Minimarket');
    expect(loaded?.rut, '12.345.678-5');
  });

  test('findActive devuelve única tienda', () async {
    final store = Store.create(
      id: 'store_01',
      rutRaw: '12.345.678-5',
      legalName: 'A',
      businessLine: 'B',
    );
    await stores.save(store);
    final active = await stores.findActive();
    expect(active?.id, 'store_01');
  });
}