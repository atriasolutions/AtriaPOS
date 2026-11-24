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
    StockMovementRepository? stockMovementRepository,
    ProductRepository? productRepository,
    UserRepository? userRepository,
    SessionProvider? sessionProvider,
  }) {
    final sales = saleRepository ?? InMemorySaleRepository();
    final movements =
        stockMovementRepository ?? InMemoryStockMovementRepository();
    final products = productRepository ?? InMemoryProductRepository();
    final users = userRepository ?? InMemoryUserRepository();
    final sessions = sessionProvider ?? InMemorySessionProvider();
    return ReportService._(
      GetDailySalesReport(sales, sessions),
      GetAuditTrail(sales, movements, products, users, sessions),
    );
  }

  ReportService._(this._getDaily, this._getAudit);

  final GetDailySalesReport _getDaily;
  final GetAuditTrail _getAudit;

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

  Future<ApiResult<AuditTrailResponse>> getAuditTrail(
    StoreId storeId, {
    String? date,
    String? from,
    String? to,
    String? categories,
  }) async {
    try {
      DateTime? fromLocal;
      DateTime? toLocal;
      if (from != null && from.trim().isNotEmpty) {
        fromLocal = parseCalendarDateYmd(from.trim());
      }
      if (to != null && to.trim().isNotEmpty) {
        toLocal = parseCalendarDateYmd(to.trim());
      }
      if (fromLocal == null && toLocal == null && date != null) {
        final calendarDay = parseCalendarDateYmd(date.trim());
        fromLocal = calendarDay;
        toLocal = calendarDay;
      }
      Set<AuditCategory>? categorySet;
      if (categories != null && categories.trim().isNotEmpty) {
        categorySet = AuditCategory.parseCsv(categories);
      }
      final trail = await _getAudit(
        storeId,
        fromLocal: fromLocal,
        toLocalInclusive: toLocal,
        categories: categorySet,
      );
      final fromDate = formatCalendarDateYmd(trail.fromLocal);
      final toDate = formatCalendarDateYmd(trail.toLocalInclusive);
      final legacyDate = fromDate == toDate ? fromDate : null;
      return ApiSuccess(
        AuditTrailResponse(
          date: legacyDate,
          fromDate: fromDate,
          toDate: toDate,
          items: [
            for (final item in trail.items)
              AuditTrailItemResponse(
                occurredAt: item.occurredAt.toUtc().toIso8601String(),
                category: item.category.apiValue,
                type: item.type,
                actorUserId: item.actorUserId,
                summary: item.summary,
                refId: item.refId,
              ),
          ],
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