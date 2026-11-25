import '../application/application.dart';
import '../domain/domain.dart';
import 'api_error.dart';
import 'api_result.dart';
import 'scan_session_dtos.dart';

class ScanSessionService {
  factory ScanSessionService({
    ScanSessionRepository? scanSessions,
    ProductRepository? products,
    StockMovementRepository? stockMovements,
    ShiftRepository? shiftRepository,
    SaleRepository? saleRepository,
    InventoryCloseRepository? inventoryCloseRepository,
    SessionProvider? sessionProvider,
  }) {
    final sessions = scanSessions ?? InMemoryScanSessionRepository();
    final prods = products ?? InMemoryProductRepository();
    final movements = stockMovements ?? InMemoryStockMovementRepository();
    final shifts = shiftRepository ?? InMemoryShiftRepository();
    final sales = saleRepository ?? InMemorySaleRepository();
    final inventoryCloses =
        inventoryCloseRepository ?? InMemoryInventoryCloseRepository();
    final provider =
        sessionProvider ?? InMemorySessionProvider.supervisor();
    final recordReceipt = RecordStockReceipt(prods, movements, provider);
    final adjustStock = AdjustStock(prods, movements, provider);
    final closeInventory = CloseInventory(
      shifts,
      prods,
      sales,
      adjustStock,
      inventoryCloses,
      provider,
    );
    return ScanSessionService._(
      StartScanSession(sessions, provider),
      RecordScanBip(sessions, ResolveScanCode(prods), provider),
      CancelScanSession(sessions, provider),
      ConfirmStockReceiptScan(sessions, recordReceipt, provider),
      ConfirmInventoryCountScan(sessions, closeInventory, provider),
      sessions,
    );
  }

  ScanSessionService._(
    this._start,
    this._bip,
    this._cancel,
    this._confirm,
    this._confirmCount,
    this._repository,
  );

  final StartScanSession _start;
  final RecordScanBip _bip;
  final CancelScanSession _cancel;
  final ConfirmStockReceiptScan _confirm;
  final ConfirmInventoryCountScan _confirmCount;
  final ScanSessionRepository _repository;

  Future<ApiResult<ScanSessionResponse>> createScanSession(
    StoreId storeId,
    CreateScanSessionRequest request,
  ) async {
    try {
      ScanSessionKind kind;
      try {
        kind = ScanSessionKind.fromApi(request.kind);
      } on ArgumentError {
        return ApiFailure(
          const ApiErrorBody(
            code: 'VALIDACION',
            message: 'Tipo de sesión inválido',
          ),
          statusCode: 400,
        );
      }

      final session = await _start(
        StartScanSessionInput(
          storeId: storeId,
          kind: kind,
          guideRef: request.guideRef,
          lotRef: request.lotRef,
        ),
      );
      return ApiSuccess(_toResponse(session), statusCode: 201);
    } on ForbiddenFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 403,
      );
    } on ValidationFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 400,
      );
    }
  }

  Future<ApiResult<ScanSessionResponse>> getScanSession(
    StoreId storeId,
    ScanSessionId sessionId,
  ) async {
    final session = await _repository.findById(storeId, sessionId);
    if (session == null) {
      return ApiFailure(
        const ApiErrorBody(
          code: 'NO_ENCONTRADO',
          message: 'Sesión de escaneo no encontrada',
        ),
        statusCode: 404,
      );
    }
    return ApiSuccess(_toResponse(session), statusCode: 200);
  }

  Future<ApiResult<ScanSessionResponse>> recordScan(
    StoreId storeId,
    ScanSessionId sessionId,
    RecordScanRequest request,
  ) async {
    try {
      final session = await _bip(
        RecordScanBipInput(
          storeId: storeId,
          sessionId: sessionId,
          code: request.code,
        ),
      );
      return ApiSuccess(_toResponse(session), statusCode: 200);
    } on ForbiddenFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 403,
      );
    } on NotFoundFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message, details: e.details),
        statusCode: 404,
      );
    } on ValidationFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 400,
      );
    }
  }

  Future<ApiResult<ConfirmScanSessionResponse>> confirmScanSession(
    StoreId storeId,
    ScanSessionId sessionId,
    ConfirmScanSessionRequest request,
  ) async {
    try {
      final result = await _confirm(
        ConfirmStockReceiptScanInput(
          storeId: storeId,
          sessionId: sessionId,
          idempotencyKey: request.idempotencyKey,
        ),
      );
      return ApiSuccess(
        _toConfirmResponse(result.session, result.lines),
        statusCode: 200,
      );
    } on ForbiddenFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 403,
      );
    } on NotFoundFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message, details: e.details),
        statusCode: 404,
      );
    } on ConflictFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message, details: e.details),
        statusCode: 409,
      );
    } on ValidationFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 400,
      );
    }
  }

  Future<ApiResult<ConfirmInventoryCountScanResponse>>
      confirmInventoryCountScan(
    StoreId storeId,
    ScanSessionId sessionId,
    ConfirmInventoryCountScanRequest request,
  ) async {
    try {
      final result = await _confirmCount(
        ConfirmInventoryCountScanInput(
          storeId: storeId,
          sessionId: sessionId,
          idempotencyKey: request.idempotencyKey,
        ),
      );
      return ApiSuccess(
        _toCountConfirmResponse(result.session, result.lines),
        statusCode: 200,
      );
    } on ForbiddenFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 403,
      );
    } on NotFoundFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message, details: e.details),
        statusCode: 404,
      );
    } on ConflictFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message, details: e.details),
        statusCode: 409,
      );
    } on ValidationFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 400,
      );
    }
  }

  Future<ApiResult<ScanSessionResponse>> cancelScanSession(
    StoreId storeId,
    ScanSessionId sessionId,
  ) async {
    try {
      final session = await _cancel(storeId, sessionId);
      return ApiSuccess(_toResponse(session), statusCode: 200);
    } on ForbiddenFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 403,
      );
    } on NotFoundFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message, details: e.details),
        statusCode: 404,
      );
    } on ValidationFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 400,
      );
    }
  }

  static ScanSessionResponse _toResponse(ScanSession session) {
    return ScanSessionResponse(
      sessionId: session.id,
      kind: session.kind.apiValue,
      state: session.state.apiValue,
      guideRef: session.guideRef,
      lotRef: session.lotRef,
      lines: session.lines
          .map(
            (l) => ScanSessionLineDto(
              productId: l.productId,
              productName: l.productName,
              quantity: l.quantity,
              lastScannedAt: l.lastScannedAt,
            ),
          )
          .toList(),
    );
  }

  static ConfirmScanSessionResponse _toConfirmResponse(
    ScanSession session,
    List<ScanSessionConfirmationLine> lines,
  ) {
    return ConfirmScanSessionResponse(
      sessionId: session.id,
      state: session.state.apiValue,
      guideRef: session.guideRef,
      lotRef: session.lotRef,
      results: lines
          .map(
            (l) => ConfirmScanSessionLineResult(
              productId: l.productId,
              quantity: l.quantity,
              stock: l.stock,
              movementId: l.movementId,
            ),
          )
          .toList(),
    );
  }

  static ConfirmInventoryCountScanResponse _toCountConfirmResponse(
    ScanSession session,
    List<ScanSessionInventoryConfirmationLine> lines,
  ) {
    return ConfirmInventoryCountScanResponse(
      sessionId: session.id,
      state: session.state.apiValue,
      closeId: session.inventoryCloseId!,
      shiftId: session.inventoryCloseShiftId!,
      closedAt: session.inventoryClosedAt!.toUtc().toIso8601String(),
      lines: lines
          .map(
            (l) => ConfirmInventoryCountScanLineResult(
              productId: l.productId,
              systemStock: l.systemStock,
              countedStock: l.countedStock,
              variance: l.variance,
              unitsSoldInShift: l.unitsSoldInShift,
            ),
          )
          .toList(),
    );
  }
}