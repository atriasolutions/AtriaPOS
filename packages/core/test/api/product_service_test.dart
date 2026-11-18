import 'package:core/api/api.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';
  late ProductService service;

  setUp(() {
    service = ProductService();
  });

  test('createProduct 201 alineado API-001', () async {
    final result = await service.createProduct(
      storeId,
      const CreateProductRequest(
        name: 'Pan hallulla',
        salePriceClp: 500,
        initialStock: 20,
      ),
    );
    expect(result, isA<ApiSuccess<ProductResponse>>());
    final success = result as ApiSuccess<ProductResponse>;
    expect(success.statusCode, 201);
    expect(success.data.stock, 20);
  });

  test('createProduct precio inválido → 400 VALIDACION', () async {
    final result = await service.createProduct(
      storeId,
      const CreateProductRequest(name: 'X', salePriceClp: 0),
    );
    expect(result, isA<ApiFailure<ProductResponse>>());
    final failure = result as ApiFailure<ProductResponse>;
    expect(failure.statusCode, 400);
    expect(failure.error.code, 'VALIDACION');
  });

  test('createProduct barcode duplicado → 409 CONFLICTO SC-010-03', () async {
    await service.createProduct(
      storeId,
      const CreateProductRequest(
        name: 'A',
        salePriceClp: 100,
        barcode: '7801234567890',
      ),
    );
    final result = await service.createProduct(
      storeId,
      const CreateProductRequest(
        name: 'B',
        salePriceClp: 200,
        barcode: '7801234567890',
      ),
    );
    expect(result, isA<ApiFailure<ProductResponse>>());
    final failure = result as ApiFailure<ProductResponse>;
    expect(failure.statusCode, 409);
    expect(failure.error.code, 'CONFLICTO');
  });

  test('searchProducts 200 con items', () async {
    await service.createProduct(
      storeId,
      const CreateProductRequest(
        name: 'Pan hallulla',
        salePriceClp: 500,
        initialStock: 20,
      ),
    );
    final result = await service.searchProducts(storeId, 'hall');
    expect(result, isA<ApiSuccess<SearchProductsResponse>>());
    final success = result as ApiSuccess<SearchProductsResponse>;
    expect(success.data.items, hasLength(1));
  });
}