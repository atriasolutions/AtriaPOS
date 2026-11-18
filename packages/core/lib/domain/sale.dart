import 'cart_id.dart';
import 'dte_status.dart';
import 'payment.dart';
import 'sale_id.dart';
import 'sale_line.dart';
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
  final DteStatus dteStatus;
  final int? folio;
  final String? pdfUrl;

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
        dteStatus: dteStatus,
        folio: folio ?? this.folio,
        pdfUrl: pdfUrl ?? this.pdfUrl,
      );
}