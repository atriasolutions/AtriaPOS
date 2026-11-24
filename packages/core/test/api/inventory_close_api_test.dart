import 'package:core/api/api.dart';
import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';

  Future<InventoryService> buildService({SessionProvider? sessions}) async {
    final shifts = InMemoryShiftRepository();
    final products = InMemoryProductRepository();
    await shifts.save(
      Shift(
        id: 'sh1',
        storeId: storeId,
        openingCashClp: 0,
        openedAt: DateTime.utc(2026, 1, 1),
        status: ShiftStatus.abierto,
      ),
    );
    await products.save(
      Product.create(
        id: 'p1',
        storeId: storeId,
        name: 'Pan',
        salePriceClp: 500,
        initialStock: 10,
      ),
    );
    return InventoryService(
      productRepository: products,
      shiftRepository: shifts,
      sessionProvider: sessions ?? InMemorySessionProvider.supervisor(),
    );
  }

  test('SC-088-01 API preview 200', () async {
    final service = await buildService();
    final result = await service.getInventoryClosePreview(storeId);
    expect(result, isA<ApiSuccess<InventoryClosePreviewResponse>>());
    expect(
      (result as ApiSuccess).data.items.single.systemStock,
      10,
    );
  });

  test('SC-088-06 cajero API 403', () async {
    final service = await buildService(
      sessions: InMemorySessionProvider.cajero(),
    );
    final result = await service.getInventoryClosePreview(storeId);
    expect(result, isA<ApiFailure<InventoryClosePreviewResponse>>());
    expect((result as ApiFailure).statusCode, 403);
  });

  test('SC-088-02 API submit 201', () async {
    final service = await buildService();
    final result = await service.submitInventoryClose(
      storeId,
      const InventoryCloseSubmitRequest(
        lines: [InventoryCloseLineRequest(productId: 'p1', countedQty: 8)],
      ),
    );
    expect(result, isA<ApiSuccess<InventoryCloseSubmitResponse>>());
    final data = (result as ApiSuccess<InventoryCloseSubmitResponse>).data;
    expect(data.lines.single.variance, -2);
    expect((result as ApiSuccess).statusCode, 201);
  });
}