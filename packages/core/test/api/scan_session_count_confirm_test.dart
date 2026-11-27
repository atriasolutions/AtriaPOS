import 'package:core/api/api.dart';
import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';
  const idempotencyKey = 'idem-088-01';

  late InMemoryStoreRepository stores;
  late InMemoryProductRepository products;
  late InMemoryStockMovementRepository movements;
  late InMemoryScanSessionRepository scanSessions;
  late InMemoryShiftRepository shifts;
  late InMemoryInventoryCloseRepository inventoryCloses;
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
    shifts = InMemoryShiftRepository();
    inventoryCloses = InMemoryInventoryCloseRepository();
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
      shiftRepository: shifts,
      inventoryCloseRepository: inventoryCloses,
      sessionProvider: supervisor,
    );
  });

  Future<void> openShift() async {
    await shifts.save(
      Shift(
        id: 'sh-count-88',
        storeId: storeId,
        openingCashClp: 0,
        openedAt: DateTime.utc(2026, 3, 1),
        status: ShiftStatus.abierto,
      ),
    );
  }

  Future<String> productWithBarcode(
    String barcode, {
    int stock = 10,
    String? name,
  }) async {
    final result = await productService.createProduct(
      storeId,
      CreateProductRequest(
        name: name ?? 'P-$barcode',
        salePriceClp: 500,
        initialStock: stock,
        barcode: barcode,
      ),
    );
    return (result as ApiSuccess<ProductResponse>).data.id;
  }

  Future<String> startCountSession() async {
    final created = await scanService.createScanSession(
      storeId,
      const CreateScanSessionRequest(kind: 'countScan'),
    );
    return (created as ApiSuccess<ScanSessionResponse>).data.sessionId;
  }

  test('SC-088-SCAN-01 confirm parcial con dos SKU', () async {
    await openShift();
    await productWithBarcode('111', stock: 10);
    await productWithBarcode('222', stock: 5);
    final sessionId = await startCountSession();

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

    final confirm = await scanService.confirmInventoryCountScan(
      storeId,
      sessionId,
      const ConfirmInventoryCountScanRequest(),
    );
    expect(confirm, isA<ApiSuccess<ConfirmInventoryCountScanResponse>>());
    final data = (confirm as ApiSuccess<ConfirmInventoryCountScanResponse>).data;
    expect(data.state, 'confirmed');
    expect(data.lines, hasLength(2));

    final line111 = data.lines.firstWhere((l) => l.countedStock == 2);
    expect(line111.systemStock, 10);
    expect(line111.variance, -8);

    final line222 = data.lines.firstWhere((l) => l.countedStock == 1);
    expect(line222.systemStock, 5);
    expect(line222.variance, -4);

    final persisted =
        await inventoryCloses.findById(storeId, data.closeId);
    expect(persisted!.lines, hasLength(2));
  });

  test('SC-088-SCAN-02 sesión sin bips → 400', () async {
    await openShift();
    final sessionId = await startCountSession();
    final result = await scanService.confirmInventoryCountScan(
      storeId,
      sessionId,
      const ConfirmInventoryCountScanRequest(),
    );
    expect(result, isA<ApiFailure<ConfirmInventoryCountScanResponse>>());
    expect((result as ApiFailure<ConfirmInventoryCountScanResponse>).statusCode,
        400);
  });

  test('SC-088-SCAN-03 receiptScan en confirm-count → 400', () async {
    await openShift();
    await productWithBarcode('444');
    final created = await scanService.createScanSession(
      storeId,
      const CreateScanSessionRequest(
        kind: 'receiptScan',
        guideRef: 'g',
        lotRef: 'l',
      ),
    );
    final sessionId =
        (created as ApiSuccess<ScanSessionResponse>).data.sessionId;
    await scanService.recordScan(
      storeId,
      sessionId,
      const RecordScanRequest(code: '444'),
    );
    final result = await scanService.confirmInventoryCountScan(
      storeId,
      sessionId,
      const ConfirmInventoryCountScanRequest(),
    );
    expect(result, isA<ApiFailure<ConfirmInventoryCountScanResponse>>());
    expect((result as ApiFailure<ConfirmInventoryCountScanResponse>).statusCode,
        400);
  });

  test('SC-088-SCAN-04 sin turno abierto → 404', () async {
    await productWithBarcode('555');
    final sessionId = await startCountSession();
    await scanService.recordScan(
      storeId,
      sessionId,
      const RecordScanRequest(code: '555'),
    );
    final result = await scanService.confirmInventoryCountScan(
      storeId,
      sessionId,
      const ConfirmInventoryCountScanRequest(),
    );
    expect(result, isA<ApiFailure<ConfirmInventoryCountScanResponse>>());
    expect((result as ApiFailure<ConfirmInventoryCountScanResponse>).statusCode,
        404);
  });

  test('SC-088-SCAN-05 idempotency replay → 200', () async {
    await openShift();
    await productWithBarcode('666', stock: 3);
    final sessionId = await startCountSession();
    await scanService.recordScan(
      storeId,
      sessionId,
      const RecordScanRequest(code: '666'),
    );
    final first = await scanService.confirmInventoryCountScan(
      storeId,
      sessionId,
      ConfirmInventoryCountScanRequest(idempotencyKey: idempotencyKey),
    );
    final second = await scanService.confirmInventoryCountScan(
      storeId,
      sessionId,
      ConfirmInventoryCountScanRequest(idempotencyKey: idempotencyKey),
    );
    expect(first, isA<ApiSuccess<ConfirmInventoryCountScanResponse>>());
    expect(second, isA<ApiSuccess<ConfirmInventoryCountScanResponse>>());
    expect(
      (first as ApiSuccess<ConfirmInventoryCountScanResponse>).data.closeId,
      (second as ApiSuccess<ConfirmInventoryCountScanResponse>).data.closeId,
    );
    final persisted = await inventoryCloses.findById(
      storeId,
      (first as ApiSuccess<ConfirmInventoryCountScanResponse>).data.closeId,
    );
    expect(persisted, isNotNull);
  });

  test('SC-088-SCAN-06 segundo confirm sin clave → 409', () async {
    await openShift();
    await productWithBarcode('777');
    final sessionId = await startCountSession();
    await scanService.recordScan(
      storeId,
      sessionId,
      const RecordScanRequest(code: '777'),
    );
    await scanService.confirmInventoryCountScan(
      storeId,
      sessionId,
      const ConfirmInventoryCountScanRequest(),
    );
    final again = await scanService.confirmInventoryCountScan(
      storeId,
      sessionId,
      const ConfirmInventoryCountScanRequest(),
    );
    expect(again, isA<ApiFailure<ConfirmInventoryCountScanResponse>>());
    expect((again as ApiFailure<ConfirmInventoryCountScanResponse>).statusCode,
        409);
  });

  test('SC-088-SCAN-07 cajero → 403', () async {
    await openShift();
    final sessionId = await startCountSession();
    final cajeroService = ScanSessionService(
      storeRepository: stores,
      scanSessions: scanSessions,
      products: products,
      stockMovements: movements,
      shiftRepository: shifts,
      inventoryCloseRepository: inventoryCloses,
      sessionProvider: InMemorySessionProvider.cajero(),
    );
    final result = await cajeroService.confirmInventoryCountScan(
      storeId,
      sessionId,
      const ConfirmInventoryCountScanRequest(),
    );
    expect(result, isA<ApiFailure<ConfirmInventoryCountScanResponse>>());
    expect((result as ApiFailure<ConfirmInventoryCountScanResponse>).statusCode,
        403);
  });

  test('SC-088-SCAN-08 regresión count en confirm ingreso → 400', () async {
    await productWithBarcode('888');
    final created = await scanService.createScanSession(
      storeId,
      const CreateScanSessionRequest(kind: 'countScan'),
    );
    final sessionId =
        (created as ApiSuccess<ScanSessionResponse>).data.sessionId;
    await scanService.recordScan(
      storeId,
      sessionId,
      const RecordScanRequest(code: '888'),
    );
    final result = await scanService.confirmScanSession(
      storeId,
      sessionId,
      const ConfirmScanSessionRequest(),
    );
    expect(result, isA<ApiFailure<ConfirmScanSessionResponse>>());
    expect((result as ApiFailure<ConfirmScanSessionResponse>).statusCode, 400);
  });
}