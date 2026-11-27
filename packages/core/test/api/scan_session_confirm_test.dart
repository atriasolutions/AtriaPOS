import 'package:core/api/api.dart';
import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';
  const idempotencyKey = 'idem-086-01';

  late InMemoryStoreRepository stores;
  late InMemoryProductRepository products;
  late InMemoryStockMovementRepository movements;
  late InMemoryScanSessionRepository scanSessions;
  late InMemorySessionProvider supervisor;
  late ScanSessionService scanService;
  late ProductService productService;

  setUp(() async {
    stores = InMemoryStoreRepository();
    await stores.save(
      Store.create(
        id: storeId,
        rutRaw: '76123456-0',
        legalName: 'Demo',
        businessLine: 'Retail',
      ),
    );
    products = InMemoryProductRepository();
    movements = InMemoryStockMovementRepository();
    scanSessions = InMemoryScanSessionRepository();
    supervisor = InMemorySessionProvider.supervisor();
    productService = ProductService(
      repository: products,
      sessionProvider: supervisor,
    );
    scanService = ScanSessionService(
      storeRepository: stores,
      scanSessions: scanSessions,
      products: products,
      stockMovements: movements,
      sessionProvider: supervisor,
    );
  });

  Future<String> productWithBarcode(String barcode, {int stock = 0}) async {
    final result = await productService.createProduct(
      storeId,
      CreateProductRequest(
        name: 'P-$barcode',
        salePriceClp: 500,
        initialStock: stock,
        barcode: barcode,
      ),
    );
    return (result as ApiSuccess<ProductResponse>).data.id;
  }

  Future<String> startReceiptSession() async {
    final created = await scanService.createScanSession(
      storeId,
      const CreateScanSessionRequest(
        kind: 'receiptScan',
        guideRef: 'gd-99',
        lotRef: 'l-99',
      ),
    );
    return (created as ApiSuccess<ScanSessionResponse>).data.sessionId;
  }

  test('SC-086-01 confirm persiste RECEPCION por producto', () async {
    await productWithBarcode('111', stock: 5);
    await productWithBarcode('222', stock: 2);
    final sessionId = await startReceiptSession();

    await scanService.recordScan(
      storeId,
      sessionId,
      const RecordScanRequest(code: '111'),
    );
    await Future<void>.delayed(const Duration(milliseconds: 450));
    await scanService.recordScan(
      storeId,
      sessionId,
      const RecordScanRequest(code: '111'),
    );
    await scanService.recordScan(
      storeId,
      sessionId,
      const RecordScanRequest(code: '222'),
    );

    final confirm = await scanService.confirmScanSession(
      storeId,
      sessionId,
      const ConfirmScanSessionRequest(),
    );
    expect(confirm, isA<ApiSuccess<ConfirmScanSessionResponse>>());
    final data = (confirm as ApiSuccess<ConfirmScanSessionResponse>).data;
    expect(data.state, 'confirmed');
    expect(data.results, hasLength(2));
    expect(
      data.results.map((r) => r.productId).toSet(),
      hasLength(2),
    );

    final r111 = data.results.firstWhere((r) => r.quantity == 2);
    expect(r111.stock, 7);

    final r222 = data.results.firstWhere((r) => r.quantity == 1);
    expect(r222.stock, 3);

    final id111 = r111.productId;
    final audit = await movements.listByProduct(storeId, id111);
    expect(audit.single.reason, StockAdjustmentReason.recepcion);
    expect(audit.single.guideRef, 'GD-99');
    expect(audit.single.lotRef, 'L-99');
    expect(audit.single.delta, 2);
  });

  test('SC-086-02 líneas vacías → 400', () async {
    final sessionId = await startReceiptSession();
    final result = await scanService.confirmScanSession(
      storeId,
      sessionId,
      const ConfirmScanSessionRequest(),
    );
    expect(result, isA<ApiFailure<ConfirmScanSessionResponse>>());
    expect((result as ApiFailure<ConfirmScanSessionResponse>).statusCode, 400);
  });

  test('SC-086-03 countScan → 400', () async {
    await productWithBarcode('333');
    final created = await scanService.createScanSession(
      storeId,
      const CreateScanSessionRequest(kind: 'countScan'),
    );
    final sessionId =
        (created as ApiSuccess<ScanSessionResponse>).data.sessionId;
    await scanService.recordScan(
      storeId,
      sessionId,
      const RecordScanRequest(code: '333'),
    );
    final result = await scanService.confirmScanSession(
      storeId,
      sessionId,
      const ConfirmScanSessionRequest(),
    );
    expect(result, isA<ApiFailure<ConfirmScanSessionResponse>>());
    expect((result as ApiFailure<ConfirmScanSessionResponse>).statusCode, 400);
  });

  test('SC-086-04 segundo confirm sin idempotency → 409', () async {
    await productWithBarcode('444');
    final sessionId = await startReceiptSession();
    await scanService.recordScan(
      storeId,
      sessionId,
      const RecordScanRequest(code: '444'),
    );
    await scanService.confirmScanSession(
      storeId,
      sessionId,
      const ConfirmScanSessionRequest(),
    );
    final again = await scanService.confirmScanSession(
      storeId,
      sessionId,
      const ConfirmScanSessionRequest(),
    );
    expect(again, isA<ApiFailure<ConfirmScanSessionResponse>>());
    expect((again as ApiFailure<ConfirmScanSessionResponse>).statusCode, 409);
  });

  test('SC-086-05 idempotency replay → 200', () async {
    await productWithBarcode('555');
    final sessionId = await startReceiptSession();
    await scanService.recordScan(
      storeId,
      sessionId,
      const RecordScanRequest(code: '555'),
    );
    final first = await scanService.confirmScanSession(
      storeId,
      sessionId,
      ConfirmScanSessionRequest(idempotencyKey: idempotencyKey),
    );
    final second = await scanService.confirmScanSession(
      storeId,
      sessionId,
      ConfirmScanSessionRequest(idempotencyKey: idempotencyKey),
    );
    expect(first, isA<ApiSuccess<ConfirmScanSessionResponse>>());
    expect(second, isA<ApiSuccess<ConfirmScanSessionResponse>>());
    expect(
      (first as ApiSuccess<ConfirmScanSessionResponse>).data.results.first
          .movementId,
      (second as ApiSuccess<ConfirmScanSessionResponse>).data.results.first
          .movementId,
    );
    final audit = await movements.listByProduct(
      storeId,
      (first as ApiSuccess<ConfirmScanSessionResponse>).data.results.first
          .productId,
    );
    expect(audit, hasLength(1));
  });

  test('SC-086-06 cajero → 403', () async {
    final sessionId = await startReceiptSession();
    final cajeroService = ScanSessionService(
      storeRepository: stores,
      scanSessions: scanSessions,
      products: products,
      stockMovements: movements,
      sessionProvider: InMemorySessionProvider.cajero(),
    );
    final result = await cajeroService.confirmScanSession(
      storeId,
      sessionId,
      const ConfirmScanSessionRequest(),
    );
    expect(result, isA<ApiFailure<ConfirmScanSessionResponse>>());
    expect((result as ApiFailure<ConfirmScanSessionResponse>).statusCode, 403);
  });

  test('SC-086-07 movimiento recepcion con refs', () async {
    final productId = await productWithBarcode('777');
    final sessionId = await startReceiptSession();
    await scanService.recordScan(
      storeId,
      sessionId,
      const RecordScanRequest(code: '777'),
    );
    await scanService.confirmScanSession(
      storeId,
      sessionId,
      const ConfirmScanSessionRequest(),
    );
    final list = await movements.listByProduct(storeId, productId);
    expect(list.single.delta, 1);
    expect(list.single.guideRef, 'GD-99');
    expect(list.single.lotRef, 'L-99');
  });
}