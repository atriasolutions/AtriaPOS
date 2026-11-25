import '../application/application.dart';
import '../domain/domain.dart';
import 'api_error.dart';
import 'api_result.dart';
import 'scan_session_dtos.dart';

class ScanSessionService {
  factory ScanSessionService({
    ScanSessionRepository? scanSessions,
    ProductRepository? products,
    SessionProvider? sessionProvider,
  }) {
    final sessions = scanSessions ?? InMemoryScanSessionRepository();
    final prods = products ?? InMemoryProductRepository();
    final provider =
        sessionProvider ?? InMemorySessionProvider.supervisor();
    return ScanSessionService._(
      StartScanSession(sessions, provider),
      RecordScanBip(sessions, ResolveScanCode(prods), provider),
      CancelScanSession(sessions, provider),
      sessions,
    );
  }

  ScanSessionService._(
    this._start,
    this._bip,
    this._cancel,
    this._repository,
  );

  final StartScanSession _start;
  final RecordScanBip _bip;
  final CancelScanSession _cancel;
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
}