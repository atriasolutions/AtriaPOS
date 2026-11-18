import '../application/application.dart';
import '../domain/domain.dart';
import 'api_error.dart';
import 'api_result.dart';
import 'shift_dtos.dart';

class ShiftService {
  factory ShiftService({
    ShiftRepository? shiftRepository,
    SaleRepository? saleRepository,
    SessionProvider? sessionProvider,
  }) {
    final shifts = shiftRepository ?? InMemoryShiftRepository();
    final sales = saleRepository ?? InMemorySaleRepository();
    final sessions =
        sessionProvider ?? InMemorySessionProvider.supervisor();
    return ShiftService._(shifts, sales, sessions);
  }

  ShiftService._(
    ShiftRepository shifts,
    SaleRepository sales,
    SessionProvider sessions,
  )   : _open = OpenShift(shifts),
        _getOpen = GetOpenShift(shifts),
        _close = CloseShift(shifts, sales, sessions);

  final OpenShift _open;
  final GetOpenShift _getOpen;
  final CloseShift _close;

  Future<ApiResult<OpenShiftResponse>> openShift(
    StoreId storeId,
    OpenShiftRequest request,
  ) async {
    try {
      final shift = await _open(storeId, request.openingCashClp);
      return ApiSuccess(
        OpenShiftResponse(
          shiftId: shift.id,
          openingCashClp: shift.openingCashClp,
        ),
        statusCode: 201,
      );
    } on ValidationFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 400,
      );
    } on ConflictFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 409,
      );
    }
  }

  Future<ApiResult<OpenShiftStatusResponse>> getOpenShift(StoreId storeId) async {
    try {
      final shift = await _getOpen(storeId);
      return ApiSuccess(
        OpenShiftStatusResponse(
          shiftId: shift.id,
          openingCashClp: shift.openingCashClp,
          openedAt: shift.openedAt.toUtc().toIso8601String(),
        ),
        statusCode: 200,
      );
    } on NotFoundFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 404,
      );
    }
  }

  Future<ApiResult<CloseShiftResponse>> closeShift(
    StoreId storeId,
    ShiftId shiftId,
    CloseShiftRequest request,
  ) async {
    try {
      final report = await _close(storeId, shiftId, request.countedCashClp);
      return ApiSuccess(
        CloseShiftResponse(
          expectedCashClp: report.expectedCashClp,
          countedCashClp: report.countedCashClp,
          differenceClp: report.differenceClp,
          salesTotalClp: report.salesTotalClp,
        ),
        statusCode: 200,
      );
    } on ValidationFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 400,
      );
    } on NotFoundFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message, details: e.details),
        statusCode: 404,
      );
    } on CredentialFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 401,
      );
    } on ForbiddenFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 403,
      );
    } on SessionExpiredFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 401,
      );
    }
  }
}