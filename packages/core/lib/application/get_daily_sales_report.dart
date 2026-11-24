import '../domain/domain.dart';
import 'auth_helpers.dart';
import 'ports/sale_repository.dart';
import 'ports/session_provider.dart';

class DailySalesReport {
  const DailySalesReport({
    required this.calendarDayLocal,
    required this.salesTotalClp,
    required this.transactionCount,
    required this.averageTicketClp,
  });

  /// Medianoche local del día reportado.
  final DateTime calendarDayLocal;
  final int salesTotalClp;
  final int transactionCount;
  final int averageTicketClp;
}

class GetDailySalesReport {
  GetDailySalesReport(this._sales, this._sessions);

  final SaleRepository _sales;
  final SessionProvider _sessions;

  Future<DailySalesReport> call(
    StoreId storeId, {
    DateTime? calendarDayLocal,
  }) async {
    AuthPolicy.require(
      requireActiveSession(_sessions),
      Permission.consultarReportes,
    );

    final dayAnchor = calendarDayLocal ?? DateTime.now();
    final from = DateTime(dayAnchor.year, dayAnchor.month, dayAnchor.day);
    final to = from.add(const Duration(days: 1));

    final sales =
        await _sales.listByStoreCreatedBetween(storeId, from, to);
    final total = shiftSalesTotalClp(sales);
    final counted = sales.where(saleCountsForShiftTotals).length;
    final average = counted > 0 ? total ~/ counted : 0;

    return DailySalesReport(
      calendarDayLocal: from,
      salesTotalClp: total,
      transactionCount: counted,
      averageTicketClp: average,
    );
  }
}