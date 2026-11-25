import 'package:core/api/api.dart';
import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';
  late ScanSessionService scanService;
  late ProductService productService;

  setUp(() {
    final products = InMemoryProductRepository();
    productService = ProductService(
      repository: products,
      sessionProvider: InMemorySessionProvider.supervisor(),
    );
    scanService = ScanSessionService(
      products: products,
      sessionProvider: InMemorySessionProvider.supervisor(),
    );
  });

  Future<String> createProductWithBarcode(String barcode) async {
    final result = await productService.createProduct(
      storeId,
      CreateProductRequest(
        name: 'SKU $barcode',
        salePriceClp: 990,
        initialStock: 0,
        barcode: barcode,
      ),
    );
    return (result as ApiSuccess<ProductResponse>).data.id;
  }

  test('SC-085-01 crear receiptScan 201', () async {
    final result = await scanService.createScanSession(
      storeId,
      const CreateScanSessionRequest(
        kind: 'receiptScan',
        guideRef: 'gd-1',
        lotRef: 'l-1',
      ),
    );
    expect(result, isA<ApiSuccess<ScanSessionResponse>>());
    final data = (result as ApiSuccess<ScanSessionResponse>).data;
    expect(data.state, 'draft');
    expect(data.guideRef, 'GD-1');
    expect(data.lotRef, 'L-1');
    expect(data.lines, isEmpty);
  });

  test('SC-085-02 countScan sin guía 201', () async {
    final result = await scanService.createScanSession(
      storeId,
      const CreateScanSessionRequest(kind: 'countScan'),
    );
    expect(result, isA<ApiSuccess<ScanSessionResponse>>());
    final data = (result as ApiSuccess<ScanSessionResponse>).data;
    expect(data.kind, 'countScan');
    expect(data.guideRef, isNull);
  });

  test('SC-085-03 bip incrementa cantidad', () async {
    await createProductWithBarcode('780111');
    final created = await scanService.createScanSession(
      storeId,
      const CreateScanSessionRequest(
        kind: 'receiptScan',
        guideRef: 'G-1',
        lotRef: 'L-1',
      ),
    );
    final sessionId =
        (created as ApiSuccess<ScanSessionResponse>).data.sessionId;

    final bip = await scanService.recordScan(
      storeId,
      sessionId,
      const RecordScanRequest(code: '780111'),
    );
    expect(bip, isA<ApiSuccess<ScanSessionResponse>>());
    final lines = (bip as ApiSuccess<ScanSessionResponse>).data.lines;
    expect(lines, hasLength(1));
    expect(lines.first.quantity, 1);

    await Future<void>.delayed(const Duration(milliseconds: 450));
    final bip2 = await scanService.recordScan(
      storeId,
      sessionId,
      const RecordScanRequest(code: '780111'),
    );
    expect(
      (bip2 as ApiSuccess<ScanSessionResponse>).data.lines.first.quantity,
      2,
    );
  });

  test('SC-085-04 antirrebote 400 ms mismo código', () async {
    final products = InMemoryProductRepository();
    final sessions = InMemoryScanSessionRepository();
    final provider = InMemorySessionProvider.supervisor();
    await ProductService(repository: products, sessionProvider: provider)
        .createProduct(
      storeId,
      const CreateProductRequest(
        name: 'X',
        salePriceClp: 100,
        initialStock: 0,
        barcode: '111',
      ),
    );
    final start = StartScanSession(sessions, provider);
    final session = await start(
      const StartScanSessionInput(
        storeId: storeId,
        kind: ScanSessionKind.countScan,
      ),
    );
    final record = RecordScanBip(
      sessions,
      ResolveScanCode(products),
      provider,
    );
    final t0 = DateTime.utc(2026, 1, 1, 12);
    await record(
      RecordScanBipInput(
        storeId: storeId,
        sessionId: session.id,
        code: '111',
        now: t0,
      ),
    );
    final debounced = await record(
      RecordScanBipInput(
        storeId: storeId,
        sessionId: session.id,
        code: '111',
        now: t0.add(const Duration(milliseconds: 200)),
      ),
    );
    expect(debounced.lines.first.quantity, 1);
    final later = await record(
      RecordScanBipInput(
        storeId: storeId,
        sessionId: session.id,
        code: '111',
        now: t0.add(const Duration(milliseconds: 500)),
      ),
    );
    expect(later.lines.first.quantity, 2);
  });

  test('SC-085-05 código desconocido 404', () async {
    final created = await scanService.createScanSession(
      storeId,
      const CreateScanSessionRequest(
        kind: 'countScan',
      ),
    );
    final sessionId =
        (created as ApiSuccess<ScanSessionResponse>).data.sessionId;
    final result = await scanService.recordScan(
      storeId,
      sessionId,
      const RecordScanRequest(code: 'nope'),
    );
    expect(result, isA<ApiFailure<ScanSessionResponse>>());
    expect((result as ApiFailure<ScanSessionResponse>).statusCode, 404);
  });

  test('SC-085-06 cajero 403', () async {
    final products = InMemoryProductRepository();
    final service = ScanSessionService(
      products: products,
      sessionProvider: InMemorySessionProvider.cajero(),
    );
    final result = await service.createScanSession(
      storeId,
      const CreateScanSessionRequest(
        kind: 'countScan',
      ),
    );
    expect(result, isA<ApiFailure<ScanSessionResponse>>());
    expect((result as ApiFailure<ScanSessionResponse>).statusCode, 403);
  });

  test('SC-085-07 cancelar sesión', () async {
    final created = await scanService.createScanSession(
      storeId,
      const CreateScanSessionRequest(
        kind: 'countScan',
      ),
    );
    final sessionId =
        (created as ApiSuccess<ScanSessionResponse>).data.sessionId;
    final cancelled = await scanService.cancelScanSession(storeId, sessionId);
    expect(
      (cancelled as ApiSuccess<ScanSessionResponse>).data.state,
      'cancelled',
    );

    final bip = await scanService.recordScan(
      storeId,
      sessionId,
      const RecordScanRequest(code: 'x'),
    );
    expect(bip, isA<ApiFailure<ScanSessionResponse>>());
    expect((bip as ApiFailure<ScanSessionResponse>).statusCode, 400);
  });
}