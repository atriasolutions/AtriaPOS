import 'package:adapters/adapters.dart';
import 'package:core/atria_pos_core.dart';
import 'package:drift/native.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';
  late AppDatabase db;
  late DriftProductRepository products;
  late DriftStockMovementRepository movements;
  late InMemorySessionProvider sessions;
  late CreateProduct createProduct;
  late RecordStockReceipt recordReceipt;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    products = DriftProductRepository(db);
    movements = DriftStockMovementRepository(db);
    sessions = InMemorySessionProvider.supervisor();
    createProduct = CreateProduct(products, sessions);
    recordReceipt = RecordStockReceipt(products, movements, sessions);
  });

  tearDown(() async {
    await db.close();
  });

  test('SC-085-06 drift persiste guide_ref y lot_ref', () async {
    final product = await createProduct(
      const CreateProductInput(
        storeId: storeId,
        name: 'Pan',
        salePriceClp: 500,
        initialStock: 3,
      ),
    );
    final result = await recordReceipt(
      RecordStockReceiptInput(
        storeId: storeId,
        productId: product.id,
        quantity: 7,
        guideRef: 'GD-99',
        lotRef: 'LOT-X',
      ),
    );
    final listed = await movements.listByProduct(storeId, product.id);
    expect(listed, hasLength(1));
    expect(listed.single.guideRef, 'GD-99');
    expect(listed.single.lotRef, 'LOT-X');
    expect(result.stock, 10);
  });
}