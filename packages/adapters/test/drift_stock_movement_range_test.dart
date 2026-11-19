import 'package:adapters/adapters.dart';
import 'package:core/pos_barrio_core.dart';
import 'package:drift/native.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';
  late AppDatabase db;
  late DriftStockMovementRepository movements;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    movements = DriftStockMovementRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('SC-070-01 drift listByStoreCreatedBetween filtra por día', () async {
    const productId = 'p1';
    await movements.save(
      StockMovement(
        id: 'm1',
        storeId: storeId,
        productId: productId,
        delta: -1,
        reason: StockAdjustmentReason.merma,
        createdAt: DateTime(2026, 3, 18, 10),
        actorId: 'usr_supervisor',
      ),
    );
    await movements.save(
      StockMovement(
        id: 'm2',
        storeId: storeId,
        productId: productId,
        delta: -2,
        reason: StockAdjustmentReason.merma,
        createdAt: DateTime(2026, 3, 19, 10),
        actorId: 'usr_supervisor',
      ),
    );

    final from = DateTime(2026, 3, 18);
    final to = from.add(const Duration(days: 1));
    final inDay = await movements.listByStoreCreatedBetween(storeId, from, to);
    expect(inDay, hasLength(1));
    expect(inDay.first.id, 'm1');
  });
}