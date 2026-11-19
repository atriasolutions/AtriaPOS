import 'package:adapters/adapters.dart';
import 'package:core/pos_barrio_core.dart';
import 'package:drift/native.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';
  late AppDatabase db;
  late DriftShiftRepository shifts;
  late DriftSaleRepository sales;
  late DriftProductRepository products;
  late DriftStockMovementRepository movements;
  late InMemoryCartRepository carts;
  late InMemorySessionProvider sessions;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    shifts = DriftShiftRepository(db);
    sales = DriftSaleRepository(db);
    products = DriftProductRepository(db);
    movements = DriftStockMovementRepository(db);
    carts = InMemoryCartRepository();
    sessions = InMemorySessionProvider.supervisor();
  });

  tearDown(() async {
    await db.close();
  });

  test('SC-070-01 drift auditoría venta y merma con actores', () async {
    await OpenShift(shifts)(storeId, 0);

    final product = await CreateProduct(products, sessions)(
      const CreateProductInput(
        storeId: storeId,
        name: 'Pan',
        salePriceClp: 500,
        initialStock: 10,
      ),
    );

    final cart = await CreateCart(carts, shifts)(storeId);
    await AddCartLine(carts, products)(
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
      FakeDteGateway(),
      InMemoryDteQueueRepository(),
      sessions,
    );
    final checkoutResult = await checkout(
      ConfirmCheckoutInput(
        storeId: storeId,
        cartId: cart.id,
        payments: const [
          CheckoutPaymentInput(method: PaymentMethod.efectivo, amountClp: 500),
        ],
        changeClp: 0,
      ),
    );

    final stored = await sales.findById(storeId, checkoutResult.saleId);
    expect(stored!.confirmedByUserId, 'usr_supervisor');

    await AdjustStock(products, movements, sessions)(
      AdjustStockInput(
        storeId: storeId,
        productId: product.id,
        delta: -2,
        reason: StockAdjustmentReason.merma,
      ),
    );

    final audit = GetAuditTrail(sales, movements, products, sessions);
    final trail = await audit(storeId);
    expect(
      trail.items.where((i) => i.type == 'CONFIRMA_VENTA'),
      hasLength(1),
    );
    expect(
      trail.items.where((i) => i.type == 'AJUSTE_STOCK'),
      hasLength(1),
    );
    expect(
      trail.items.every((i) => i.actorUserId == 'usr_supervisor'),
      isTrue,
    );
    expect(
      trail.items.any((i) => i.type == 'AJUSTE_STOCK' && i.summary.contains('VENTA')),
      isFalse,
    );
  });
}