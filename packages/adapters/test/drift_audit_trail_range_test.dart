import 'package:adapters/adapters.dart';
import 'package:core/atria_pos_core.dart';
import 'package:drift/native.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';

  test('SC-086-07 drift persiste voided_at y created_at', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final sales = DriftSaleRepository(db);
    final users = DriftUserRepository(db);
    const shiftId = 'sh1';
    final voidedAt = DateTime.utc(2026, 3, 10, 16);
    await sales.save(
      Sale(
        id: 'sale_void',
        storeId: storeId,
        shiftId: shiftId,
        cartId: 'cart1',
        lines: const [],
        payments: const [],
        totalClp: 300,
        changeClp: 0,
        createdAt: DateTime.utc(2026, 3, 9),
        status: SaleStatus.anulada,
        voidedAt: voidedAt,
        voidedByUserId: 'usr_supervisor',
      ),
    );
    final createdAt = DateTime.utc(2026, 3, 12, 9);
    await users.save(
      User(
        id: 'usr_new',
        storeId: storeId,
        role: UserRole.cajero,
        pinHash: 'hash',
        username: 'usr_nuevo',
        firstName: 'Nuevo',
        lastName: 'User',
        rut: '12.345.678-5',
        createdAt: createdAt,
        createdByUserId: 'usr_supervisor',
      ),
    );

    final storedSale = await sales.findById(storeId, 'sale_void');
    expect(storedSale!.voidedAt, voidedAt);
    expect(storedSale.voidedByUserId, 'usr_supervisor');

    final storedUser = await users.findById(storeId, 'usr_new');
    expect(storedUser!.createdAt, createdAt);
    expect(storedUser.createdByUserId, 'usr_supervisor');
  });

  test('SC-086-08 drift auditoría ANULA_VENTA', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final sales = DriftSaleRepository(db);
    final movements = DriftStockMovementRepository(db);
    final products = DriftProductRepository(db);
    final users = DriftUserRepository(db);
    final sessions = InMemorySessionProvider.supervisor();
    final voidedAt = DateTime(2026, 3, 18, 14);
    await sales.save(
      Sale(
        id: 'sale_v',
        storeId: storeId,
        shiftId: 'sh1',
        cartId: 'c1',
        lines: const [],
        payments: const [],
        totalClp: 400,
        changeClp: 0,
        createdAt: DateTime(2026, 3, 17, 10),
        status: SaleStatus.anulada,
        voidedAt: voidedAt,
        voidedByUserId: 'usr_supervisor',
      ),
    );

    final audit = GetAuditTrail(sales, movements, products, users, sessions);
    final trail = await audit(
      storeId,
      fromLocal: DateTime(2026, 3, 18),
      toLocalInclusive: DateTime(2026, 3, 18),
      categories: {AuditCategory.ventas},
    );
    expect(trail.items.single.type, 'ANULA_VENTA');
    expect(trail.items.single.category, AuditCategory.ventas);
  });
}