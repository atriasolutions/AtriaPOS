import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

import '../support/collaborator_fixtures.dart';

void main() {
  const storeId = 't1';

  test('SC-070-01 auditoría incluye venta y merma con actores', () async {
    final products = InMemoryProductRepository();
    final sales = InMemorySaleRepository();
    final movements = InMemoryStockMovementRepository();
    final shifts = InMemoryShiftRepository();
    final carts = InMemoryCartRepository();
    final collaborators = InMemoryCollaboratorRepository();
    await seedDefaultSeller(collaborators, storeId);
    final sessions = InMemorySessionProvider.supervisor();

    final createProduct = CreateProduct(products, sessions);
    final openShift = OpenShift(shifts);
    await openShift(storeId, 0);

    final product = await createProduct(
      const CreateProductInput(
        storeId: storeId,
        name: 'Pan',
        salePriceClp: 500,
        initialStock: 10,
      ),
    );

    final cart = await CreateCart(carts, shifts, sessions)(storeId);
    await AddCartLine(carts, products, sessions)(
      AddCartLineInput(
        storeId: storeId,
        cartId: cart.id,
        productId: product.id,
        quantity: 1,
      ),
    );

    final checkout = ConfirmCheckout(
      carts,
      products,
      sales,
      movements,
      shifts,
      collaborators,
      InMemoryStoreRepository(),
      FakeDteGateway(),
      InMemoryDteQueueRepository(),
      sessions,
    );
    await checkout(
      ConfirmCheckoutInput(
        storeId: storeId,
        cartId: cart.id,
        sellerCode: 'V01',
        payments: const [
          CheckoutPaymentInput(method: PaymentMethod.efectivo, amountClp: 500),
        ],
        changeClp: 0,
      ),
    );

    final adjust = AdjustStock(products, movements, sessions);
    await adjust(
      AdjustStockInput(
        storeId: storeId,
        productId: product.id,
        delta: -2,
        reason: StockAdjustmentReason.merma,
      ),
    );

    final users = InMemoryUserRepository();
    final audit = GetAuditTrail(sales, movements, products, users, sessions);
    final trail = await audit(storeId);
    expect(trail.items.length, greaterThanOrEqualTo(2));
    expect(
      trail.items.any((i) => i.type == 'CONFIRMA_VENTA' && i.actorUserId != null),
      isTrue,
    );
    expect(
      trail.items.any((i) => i.type == 'AJUSTE_STOCK' && i.actorUserId != null),
      isTrue,
    );
  });

  test('SC-085-07 auditoría incluye ingreso con guía y lote', () async {
    final stores = InMemoryStoreRepository();
    await stores.save(
      Store.create(
        id: storeId,
        rutRaw: '76123456-0',
        legalName: 'Demo',
        businessLine: 'Retail',
      ),
    );
    final products = InMemoryProductRepository();
    final sales = InMemorySaleRepository();
    final movements = InMemoryStockMovementRepository();
    final sessions = InMemorySessionProvider.supervisor();
    final createProduct = CreateProduct(products, sessions);
    final product = await createProduct(
      const CreateProductInput(
        storeId: storeId,
        name: 'Arroz',
        salePriceClp: 1000,
        initialStock: 2,
      ),
    );
    final receipt = RecordStockReceipt(stores, products, movements, sessions);
    await receipt(
      RecordStockReceiptInput(
        storeId: storeId,
        productId: product.id,
        quantity: 5,
        guideRef: 'GD-10',
        lotRef: 'L-20',
      ),
    );
    final users = InMemoryUserRepository();
    final audit = GetAuditTrail(sales, movements, products, users, sessions);
    final trail = await audit(storeId);
    final ingreso = trail.items.where((i) => i.type == 'AJUSTE_STOCK');
    expect(
      ingreso.any((i) => i.summary.contains('GD-10') && i.summary.contains('L-20')),
      isTrue,
    );
  });

  test('SC-086-01 rango incluye ventas de dos días', () async {
    final sales = InMemorySaleRepository();
    final movements = InMemoryStockMovementRepository();
    final products = InMemoryProductRepository();
    final users = InMemoryUserRepository();
    final sessions = InMemorySessionProvider.supervisor();

    await sales.save(
      Sale(
        id: 's1',
        storeId: storeId,
        shiftId: 'sh1',
        cartId: 'c1',
        lines: const [],
        payments: const [],
        totalClp: 100,
        changeClp: 0,
        createdAt: DateTime(2026, 3, 1, 12),
        confirmedByUserId: 'usr_supervisor',
      ),
    );
    await sales.save(
      Sale(
        id: 's2',
        storeId: storeId,
        shiftId: 'sh1',
        cartId: 'c2',
        lines: const [],
        payments: const [],
        totalClp: 200,
        changeClp: 0,
        createdAt: DateTime(2026, 3, 7, 12),
        confirmedByUserId: 'usr_supervisor',
      ),
    );

    final audit = GetAuditTrail(sales, movements, products, users, sessions);
    final trail = await audit(
      storeId,
      fromLocal: DateTime(2026, 3, 1),
      toLocalInclusive: DateTime(2026, 3, 7),
    );
    expect(
      trail.items.where((i) => i.type == 'CONFIRMA_VENTA'),
      hasLength(2),
    );
  });

  test('SC-086-03 categories=VENTAS excluye inventario', () async {
    final sales = InMemorySaleRepository();
    final movements = InMemoryStockMovementRepository();
    final products = InMemoryProductRepository();
    final users = InMemoryUserRepository();
    final sessions = InMemorySessionProvider.supervisor();

    await sales.save(
      Sale(
        id: 's1',
        storeId: storeId,
        shiftId: 'sh1',
        cartId: 'c1',
        lines: const [],
        payments: const [],
        totalClp: 100,
        changeClp: 0,
        createdAt: DateTime(2026, 3, 5, 10),
        confirmedByUserId: 'usr_supervisor',
      ),
    );
    await movements.save(
      StockMovement(
        id: 'm1',
        storeId: storeId,
        productId: 'p1',
        delta: -1,
        reason: StockAdjustmentReason.merma,
        createdAt: DateTime(2026, 3, 5, 11),
        actorId: 'usr_supervisor',
      ),
    );

    final audit = GetAuditTrail(sales, movements, products, users, sessions);
    final trail = await audit(
      storeId,
      fromLocal: DateTime(2026, 3, 5),
      toLocalInclusive: DateTime(2026, 3, 5),
      categories: {AuditCategory.ventas},
    );
    expect(trail.items, hasLength(1));
    expect(trail.items.single.type, 'CONFIRMA_VENTA');
    expect(trail.items.single.category, AuditCategory.ventas);
  });

  test('SC-086-04 categories=USUARIOS solo CREA_USUARIO', () async {
    final sales = InMemorySaleRepository();
    final movements = InMemoryStockMovementRepository();
    final products = InMemoryProductRepository();
    final users = InMemoryUserRepository();
    final sessions = InMemorySessionProvider.supervisor();

    await users.save(
      User(
        id: 'u1',
        storeId: storeId,
        role: UserRole.cajero,
        pinHash: 'h',
        username: 'nuevo_cajero',
        firstName: 'N',
        lastName: 'U',
        rut: '12.345.678-5',
        createdAt: DateTime(2026, 4, 1, 10),
        createdByUserId: 'usr_dueno',
      ),
    );

    final audit = GetAuditTrail(sales, movements, products, users, sessions);
    final trail = await audit(
      storeId,
      fromLocal: DateTime(2026, 4, 1),
      toLocalInclusive: DateTime(2026, 4, 1),
      categories: {AuditCategory.usuarios},
    );
    expect(trail.items, hasLength(1));
    expect(trail.items.single.type, 'CREA_USUARIO');
    expect(trail.items.single.category, AuditCategory.usuarios);
  });

  test('SC-086-08 ANULA_VENTA por voidedAt', () async {
    final sales = InMemorySaleRepository();
    final movements = InMemoryStockMovementRepository();
    final products = InMemoryProductRepository();
    final users = InMemoryUserRepository();
    final sessions = InMemorySessionProvider.supervisor();
    final voidedAt = DateTime(2026, 3, 10, 15);
    await sales.save(
      Sale(
        id: 's1',
        storeId: storeId,
        shiftId: 'sh1',
        cartId: 'c1',
        lines: const [],
        payments: const [],
        totalClp: 500,
        changeClp: 0,
        createdAt: DateTime(2026, 3, 9, 10),
        status: SaleStatus.anulada,
        voidedAt: voidedAt,
        voidedByUserId: 'usr_supervisor',
      ),
    );

    final audit = GetAuditTrail(sales, movements, products, users, sessions);
    final trail = await audit(
      storeId,
      fromLocal: DateTime(2026, 3, 10),
      toLocalInclusive: DateTime(2026, 3, 10),
      categories: {AuditCategory.ventas},
    );
    expect(trail.items.single.type, 'ANULA_VENTA');
    expect(trail.items.single.occurredAt, voidedAt);
  });

  test('SC-070-01 cajero no consulta auditoría', () async {
    final sessions = InMemorySessionProvider.cajero();
    final audit = GetAuditTrail(
      InMemorySaleRepository(),
      InMemoryStockMovementRepository(),
      InMemoryProductRepository(),
      InMemoryUserRepository(),
      sessions,
    );
    expect(
      () => audit(storeId),
      throwsA(isA<ForbiddenFailure>()),
    );
  });
}