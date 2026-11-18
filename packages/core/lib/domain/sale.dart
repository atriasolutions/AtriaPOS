import 'cart_id.dart';
import 'dte_status.dart';
import 'payment.dart';
import 'sale_id.dart';
import 'sale_line.dart';
import 'sale_status.dart';
import 'shift_id.dart';
import 'store_id.dart';

class Sale {
  Sale({
    required this.id,
    required this.storeId,
    required this.shiftId,
    required this.cartId,
    required this.lines,
    required this.payments,
    required this.totalClp,
    required this.changeClp,
    required this.createdAt,
    this.status = SaleStatus.confirmada,
    this.dteStatus = DteStatus.pendienteDte,
    this.folio,
    this.pdfUrl,
  });

  final SaleId id;
  final StoreId storeId;
  final ShiftId shiftId;
  final CartId cartId;
  final List<SaleLine> lines;
  final List<Payment> payments;
  final int totalClp;
  final int changeClp;
  final DateTime createdAt;
  final SaleStatus status;
  final DteStatus dteStatus;
  final int? folio;
  final String? pdfUrl;

  bool get isAnulada => status == SaleStatus.anulada;

  Sale markAnulada() => Sale(
        id: id,
        storeId: storeId,
        shiftId: shiftId,
        cartId: cartId,
        lines: lines,
        payments: payments,
        totalClp: totalClp,
        changeClp: changeClp,
        createdAt: createdAt,
        status: SaleStatus.anulada,
        dteStatus: dteStatus,
        folio: folio,
        pdfUrl: pdfUrl,
      );

  Sale withDte({
    required DteStatus dteStatus,
    int? folio,
    String? pdfUrl,
  }) =>
      Sale(
        id: id,
        storeId: storeId,
        shiftId: shiftId,
        cartId: cartId,
        lines: lines,
        payments: payments,
        totalClp: totalClp,
        changeClp: changeClp,
        createdAt: createdAt,
        status: status,
        dteStatus: dteStatus,
        folio: folio ?? this.folio,
        pdfUrl: pdfUrl ?? this.pdfUrl,
      );
}