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
        documentType: 39,
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

abstract class DteGateway {
  Future<DteEmitResult> emit(DteEmitRequest request);
}