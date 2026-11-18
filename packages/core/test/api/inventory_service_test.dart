import 'package:core/api/api.dart';
import 'package:core/application/application.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';
  late ProductRepository products;
  late StockMovementRepository movements;
  late ProductService productService;
  late InventoryService inventoryService;

  setUp(() {
    products = InMemoryProductRepository();
    movements = InMemoryStockMovementRepository();
    productService = ProductService(repository: products);
    inventoryService = InventoryService(
      productRepository: products,
      stockMovementRepository: movements,
    );
  });

  Future<String> createPan() async {
    final result = await productService.createProduct(
      storeId,
      const CreateProductRequest(
        name: 'Pan',
        salePriceClp: 500,
        initialStock: 20,
      ),
    );
    return (result as ApiSuccess<ProductResponse>).data.id;
  }

  test('getProductStock 200 SC-020-01', () async {
    final id = await createPan();
    final result = await inventoryService.getProductStock(storeId, id);
    expect(result, isA<ApiSuccess<StockResponse>>());
    final success = result as ApiSuccess<StockResponse>;
    expect(success.statusCode, 200);
    expect(success.data.stock, 20);
  });

  test('getProductStock 404 SC-020-02', () async {
    final result = await inventoryService.getProductStock(storeId, 'nope');
    expect(result, isA<ApiFailure<StockResponse>>());
    expect((result as ApiFailure<StockResponse>).error.code, 'NO_ENCONTRADO');
  });

  test('adjustStock 200 SC-021-01', () async {
    final id = await createPan();
    final result = await inventoryService.adjustStock(
      storeId,
      id,
      const AdjustStockRequest(delta: -3, reason: 'MERMA', note: 'Vencimiento'),
    );
    expect(result, isA<ApiSuccess<AdjustStockResponse>>());
    final success = result as ApiSuccess<AdjustStockResponse>;
    expect(success.data.stock, 17);
    expect(success.data.movementId, isNotEmpty);
  });

  test('adjustStock 400 SC-021-03 motivo inválido', () async {
    final id = await createPan();
    final result = await inventoryService.adjustStock(
      storeId,
      id,
      const AdjustStockRequest(delta: -1, reason: 'INVALIDO'),
    );
    expect(result, isA<ApiFailure<AdjustStockResponse>>());
    final failure = result as ApiFailure<AdjustStockResponse>;
    expect(failure.statusCode, 400);
    expect(failure.error.code, 'VALIDACION');
  });

  test('adjustStock 400 SC-021-03 delta cero', () async {
    final id = await createPan();
    final result = await inventoryService.adjustStock(
      storeId,
      id,
      const AdjustStockRequest(delta: 0, reason: 'AJUSTE'),
    );
    expect(result, isA<ApiFailure<AdjustStockResponse>>());
    expect((result as ApiFailure<AdjustStockResponse>).error.code, 'VALIDACION');
  });

  test('adjustStock 400 SC-021-02', () async {
    final id = await createPan();
    final created = await inventoryService.getProductStock(storeId, id);
    final stock = (created as ApiSuccess<StockResponse>).data.stock;
    final result = await inventoryService.adjustStock(
      storeId,
      id,
      AdjustStockRequest(delta: -(stock + 3), reason: 'MERMA'),
    );
    expect(result, isA<ApiFailure<AdjustStockResponse>>());
    expect((result as ApiFailure<AdjustStockResponse>).error.code, 'VALIDACION');
  });
}