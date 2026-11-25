import 'credit_note_id.dart';
import 'credit_note_line.dart';
import 'dte_document_type.dart';
import 'dte_status.dart';
import 'sale_id.dart';
import 'store_id.dart';
import 'user_id.dart';

class CreditNote {
  const CreditNote({
    required this.id,
    required this.storeId,
    required this.saleId,
    required this.lines,
    required this.totalClp,
    required this.dteStatus,
    required this.createdAt,
    required this.actorUserId,
    required this.referencedSaleFolio,
    required this.referencedDocumentType,
    this.folio,
    this.pdfUrl,
  });

  final CreditNoteId id;
  final StoreId storeId;
  final SaleId saleId;
  final List<CreditNoteLine> lines;
  final int totalClp;
  final DteStatus dteStatus;
  final int? folio;
  final String? pdfUrl;
  final DateTime createdAt;
  final UserId actorUserId;
  final int referencedSaleFolio;
  final int referencedDocumentType;

  bool get isEmitida => dteStatus == DteStatus.emitida;

  CreditNote withDte({
    required DteStatus dteStatus,
    int? folio,
    String? pdfUrl,
  }) {
    return CreditNote(
      id: id,
      storeId: storeId,
      saleId: saleId,
      lines: lines,
      totalClp: totalClp,
      dteStatus: dteStatus,
      folio: folio ?? this.folio,
      pdfUrl: pdfUrl ?? this.pdfUrl,
      createdAt: createdAt,
      actorUserId: actorUserId,
      referencedSaleFolio: referencedSaleFolio,
      referencedDocumentType: referencedDocumentType,
    );
  }

  static int defaultReferencedDocType() => DteDocumentType.boleta;
}