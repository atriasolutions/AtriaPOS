import 'package:core/api/api.dart';
import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';
  late InventoryService inventoryService;
  late ProductService productService;

  setUp(() async {
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
    final movements = InMemoryStockMovementRepository();
    productService = ProductService(repository: products);
    inventoryService = InventoryService(
      storeRepository: stores,
      productRepository: products,
      stockMovementRepository: movements,
      sessionProvider: InMemorySessionProvider.supervisor(),
    );
  });

  Future<String> createPan({int stock = 5}) async {
    final result = await productService.createProduct(
      storeId,
      CreateProductRequest(
        name: 'Pan',
        salePriceClp: 500,
        initialStock: stock,
      ),
    );
    return (result as ApiSuccess<ProductResponse>).data.id;
  }

  test('SC-085-01 API ingreso 200', () async {
    final productId = await createPan();
    final result = await inventoryService.recordStockReceipt(
      storeId,
      productId,
      const StockReceiptRequest(
        quantity: 10,
        guideRef: 'GD-1',
        lotRef: 'L-1',
      ),
    );
    expect(result, isA<ApiSuccess<StockReceiptResponse>>());
    final data = (result as ApiSuccess<StockReceiptResponse>).data;
    expect(data.stock, 15);
    expect(data.guideRef, 'GD-1');
    expect(data.lotRef, 'L-1');
  });

  test('SC-085-05 adjustments RECEPCION → 400', () async {
    final productId = await createPan();
    final result = await inventoryService.adjustStock(
      storeId,
      productId,
      const AdjustStockRequest(
        delta: 5,
        reason: 'RECEPCION',
      ),
    );
    expect(result, isA<ApiFailure<AdjustStockResponse>>());
    expect((result as ApiFailure<AdjustStockResponse>).statusCode, 400);
  });

  test('SC-085-04 cajero ingreso → 403', () async {
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
    final productId = await ProductService(repository: products).createProduct(
      storeId,
      const CreateProductRequest(
        name: 'Pan',
        salePriceClp: 500,
        initialStock: 5,
      ),
    );
    final id = (productId as ApiSuccess<ProductResponse>).data.id;
    final service = InventoryService(
      storeRepository: stores,
      productRepository: products,
      stockMovementRepository: InMemoryStockMovementRepository(),
      sessionProvider: InMemorySessionProvider.cajero(),
    );
    final result = await service.recordStockReceipt(
      storeId,
      id,
      const StockReceiptRequest(
        quantity: 1,
        guideRef: 'G1',
        lotRef: 'L1',
      ),
    );
    expect(result, isA<ApiFailure<StockReceiptResponse>>());
    expect((result as ApiFailure<StockReceiptResponse>).statusCode, 403);
  });
}