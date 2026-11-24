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

    final audit = GetAuditTrail(sales, movements, products, sessions);
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
    final receipt = RecordStockReceipt(products, movements, sessions);
    await receipt(
      RecordStockReceiptInput(
        storeId: storeId,
        productId: product.id,
        quantity: 5,
        guideRef: 'GD-10',
        lotRef: 'L-20',
      ),
    );
    final audit = GetAuditTrail(sales, movements, products, sessions);
    final trail = await audit(storeId);
    final ingreso = trail.items.where((i) => i.type == 'AJUSTE_STOCK');
    expect(
      ingreso.any((i) => i.summary.contains('GD-10') && i.summary.contains('L-20')),
      isTrue,
    );
  });

  test('SC-070-01 cajero no consulta auditoría', () async {
    final sessions = InMemorySessionProvider.cajero();
    final audit = GetAuditTrail(
      InMemorySaleRepository(),
      InMemoryStockMovementRepository(),
      InMemoryProductRepository(),
      sessions,
    );
    expect(
      () => audit(storeId),
      throwsA(isA<ForbiddenFailure>()),
    );
  });
}