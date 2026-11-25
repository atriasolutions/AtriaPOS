import 'cart_id.dart';
import 'dte_document_type.dart';
import 'dte_status.dart';
import 'payment.dart';
import 'sale_invoice_receiver.dart';
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
    this.confirmedByUserId,
    this.sellerCode,
    this.voidedAt,
    this.voidedByUserId,
    int? dteDocumentType,
    this.invoiceReceiver,
  }) : dteDocumentType = dteDocumentType ?? DteDocumentType.boleta;

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
  final String? confirmedByUserId;
  final String? sellerCode;
  final DateTime? voidedAt;
  final String? voidedByUserId;
  final int dteDocumentType;
  final SaleInvoiceReceiver? invoiceReceiver;

  bool get isAnulada => status == SaleStatus.anulada;

  Sale markAnulada({
    required DateTime voidedAt,
    required String voidedByUserId,
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
        status: SaleStatus.anulada,
        dteStatus: dteStatus,
        folio: folio,
        pdfUrl: pdfUrl,
        confirmedByUserId: confirmedByUserId,
        sellerCode: sellerCode,
        voidedAt: voidedAt.toUtc(),
        voidedByUserId: voidedByUserId,
        dteDocumentType: dteDocumentType,
        invoiceReceiver: invoiceReceiver,
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
        confirmedByUserId: confirmedByUserId,
        sellerCode: sellerCode,
        voidedAt: voidedAt,
        voidedByUserId: voidedByUserId,
        dteDocumentType: dteDocumentType,
        invoiceReceiver: invoiceReceiver,
      );
}