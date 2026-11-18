import '../application/application.dart';
import '../domain/domain.dart';
import 'api_error.dart';
import 'api_result.dart';
import 'report_dtos.dart';

String formatCalendarDateYmd(DateTime localMidnight) {
  final y = localMidnight.year.toString().padLeft(4, '0');
  final m = localMidnight.month.toString().padLeft(2, '0');
  final d = localMidnight.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

DateTime parseCalendarDateYmd(String date) {
  final parts = date.split('-');
  if (parts.length != 3) {
    throw const ValidationFailure('Fecha inválida (use YYYY-MM-DD)');
  }
  final year = int.tryParse(parts[0]);
  final month = int.tryParse(parts[1]);
  final day = int.tryParse(parts[2]);
  if (year == null || month == null || day == null) {
    throw const ValidationFailure('Fecha inválida (use YYYY-MM-DD)');
  }
  if (month < 1 || month > 12 || day < 1 || day > 31) {
    throw const ValidationFailure('Fecha inválida (use YYYY-MM-DD)');
  }
  return DateTime(year, month, day);
}

class ReportService {
  factory ReportService({
    SaleRepository? saleRepository,
    SessionProvider? sessionProvider,
  }) {
    final sales = saleRepository ?? InMemorySaleRepository();
    final sessions = sessionProvider ?? InMemorySessionProvider();
    return ReportService._(
      GetDailySalesReport(sales, sessions),
    );
  }

  ReportService._(this._getDaily);

  final GetDailySalesReport _getDaily;

  Future<ApiResult<DailySalesReportResponse>> getDailySales(
    StoreId storeId, {
    String? date,
  }) async {
    try {
      final calendarDay =
          date == null ? null : parseCalendarDateYmd(date.trim());
      final report = await _getDaily(storeId, calendarDayLocal: calendarDay);
      return ApiSuccess(
        DailySalesReportResponse(
          date: formatCalendarDateYmd(report.calendarDayLocal),
          salesTotalClp: report.salesTotalClp,
          transactionCount: report.transactionCount,
          averageTicketClp: report.averageTicketClp,
        ),
        statusCode: 200,
      );
    } on ValidationFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 400,
      );
    } on ForbiddenFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 403,
      );
    } on CredentialFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 401,
      );
    }
  }
}