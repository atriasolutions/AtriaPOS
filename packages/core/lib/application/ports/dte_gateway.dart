import '../../domain/domain.dart';

class DteEmitRequest {
  const DteEmitRequest({
    required this.saleId,
    required this.storeId,
    required this.totalClp,
    required this.documentType,
  });

  final SaleId saleId;
  final StoreId storeId;
  final int totalClp;
  final int documentType;

  factory DteEmitRequest.fromSale(Sale sale) => DteEmitRequest(
        saleId: sale.id,
        storeId: sale.storeId,
        totalClp: sale.totalClp,
        documentType: sale.dteDocumentType,
      );
}

class DteEmitResult {
  const DteEmitResult({
    required this.status,
    this.folio,
    this.pdfUrl,
    this.errorMessage,
  });

  final DteStatus status;
  final int? folio;
  final String? pdfUrl;
  final String? errorMessage;
}

class DteCreditNoteEmitRequest {
  const DteCreditNoteEmitRequest({
    required this.creditNoteId,
    required this.storeId,
    required this.referencedSaleId,
    required this.referencedSaleFolio,
    required this.referencedDocumentType,
    required this.referencedSaleCreatedAt,
    required this.totalClp,
    required this.lines,
  });

  final String creditNoteId;
  final StoreId storeId;
  final SaleId referencedSaleId;
  final int referencedSaleFolio;
  final int referencedDocumentType;
  final DateTime referencedSaleCreatedAt;
  final int totalClp;
  final List<DteCreditNoteLineRequest> lines;
}

class DteCreditNoteLineRequest {
  const DteCreditNoteLineRequest({
    required this.productName,
    required this.quantity,
    required this.unitPriceClp,
  });

  final String productName;
  final int quantity;
  final int unitPriceClp;
}

abstract class DteGateway {
  Future<DteEmitResult> emit(DteEmitRequest request);

  Future<DteEmitResult> emitCreditNote(DteCreditNoteEmitRequest request);
}