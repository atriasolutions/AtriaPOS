import 'sale_id.dart';
import 'store_id.dart';

class DteQueueEntry {
  DteQueueEntry({
    required this.saleId,
    required this.storeId,
    required this.attempts,
    required this.createdAt,
    this.lastError,
  });

  final SaleId saleId;
  final StoreId storeId;
  final int attempts;
  final String? lastError;
  final DateTime createdAt;

  DteQueueEntry withAttempt(String? error) => DteQueueEntry(
        saleId: saleId,
        storeId: storeId,
        attempts: attempts + 1,
        lastError: error,
        createdAt: createdAt,
      );
}