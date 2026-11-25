import 'dte_document_type.dart';
import 'sale_id.dart';
import 'store_id.dart';

class DteQueueEntry {
  DteQueueEntry({
    required this.saleId,
    required this.storeId,
    required this.attempts,
    required this.createdAt,
    this.lastError,
    int? documentType,
    String? documentId,
  })  : documentType = documentType ?? DteDocumentType.boleta,
        documentId = documentId ?? saleId;

  final SaleId saleId;
  final StoreId storeId;
  final int documentType;
  final String documentId;
  final int attempts;
  final String? lastError;
  final DateTime createdAt;

  DteQueueEntry withAttempt(String? error) => DteQueueEntry(
        saleId: saleId,
        storeId: storeId,
        documentType: documentType,
        documentId: documentId,
        attempts: attempts + 1,
        lastError: error,
        createdAt: createdAt,
      );
}