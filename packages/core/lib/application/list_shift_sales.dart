import '../domain/domain.dart';
import 'auth_helpers.dart';
import 'ports/sale_repository.dart';
import 'ports/session_provider.dart';
import 'ports/shift_repository.dart';

class ShiftSaleListItem {
  const ShiftSaleListItem({
    required this.saleId,
    required this.totalClp,
    required this.status,
    required this.dteStatus,
    this.folio,
    required this.createdAt,
    this.sellerCode,
  });

  final SaleId saleId;
  final int totalClp;
  final SaleStatus status;
  final DteStatus dteStatus;
  final int? folio;
  final DateTime createdAt;
  final String? sellerCode;
}

class ListShiftSales {
  ListShiftSales(this._sales, this._shifts, this._sessions);

  final SaleRepository _sales;
  final ShiftRepository _shifts;
  final SessionProvider _sessions;

  Future<List<ShiftSaleListItem>> call(StoreId storeId) async {
    AuthPolicy.require(
      requireActiveSession(_sessions),
      Permission.listarVentasTurno,
    );

    final openShift = await _shifts.findOpenByStore(storeId);
    if (openShift == null) {
      throw const TurnClosedFailure(
        'No hay turno abierto para listar ventas',
      );
    }

    final sales = await _sales.listByShift(storeId, openShift.id);
    sales.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return sales
        .map(
          (sale) => ShiftSaleListItem(
            saleId: sale.id,
            totalClp: sale.totalClp,
            status: sale.status,
            dteStatus: sale.dteStatus,
            folio: sale.folio,
            createdAt: sale.createdAt,
            sellerCode: sale.sellerCode,
          ),
        )
        .toList();
  }
}