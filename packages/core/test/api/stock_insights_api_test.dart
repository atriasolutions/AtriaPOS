import 'package:core/api/api.dart';
import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';

  test('SC-087-01 API stock insights 200', () async {
    final products = InMemoryProductRepository();
    final sales = InMemorySaleRepository();
    await products.save(
      Product.create(
        id: 'p1',
        storeId: storeId,
        name: 'Pan',
        salePriceClp: 500,
        initialStock: 1,
      ),
    );
    final service = ReportService(
      productRepository: products,
      saleRepository: sales,
      sessionProvider: InMemorySessionProvider.supervisor(),
    );
    final result = await service.getStockInsights(
      storeId,
      asOf: '2026-03-18',
    );
    expect(result, isA<ApiSuccess<StockInsightsResponse>>());
    final data = (result as ApiSuccess<StockInsightsResponse>).data;
    expect(data.asOfDate, '2026-03-18');
    expect(data.defaultLowStockThreshold, 5);
    expect(data.lowStock, hasLength(1));
  });

  test('SC-087-06 cajero API 403', () async {
    final service = ReportService(
      sessionProvider: InMemorySessionProvider.cajero(),
    );
    final result = await service.getStockInsights(storeId);
    expect(result, isA<ApiFailure<StockInsightsResponse>>());
    expect((result as ApiFailure).statusCode, 403);
  });

  test('limit inválido → 400', () async {
    final service = ReportService(
      sessionProvider: InMemorySessionProvider.supervisor(),
    );
    final result = await service.getStockInsights(storeId, limit: 0);
    expect(result, isA<ApiFailure<StockInsightsResponse>>());
    expect((result as ApiFailure).statusCode, 400);
  });
}