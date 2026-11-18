import '../domain/domain.dart';
import 'emit_sale_dte.dart';
import 'ports/dte_gateway.dart';
import 'ports/dte_queue_repository.dart';
import 'ports/sale_repository.dart';

class RetryPendingDteResult {
  const RetryPendingDteResult({
    required this.processed,
    required this.failed,
  });

  final int processed;
  final int failed;
}

class RetryPendingDte {
  RetryPendingDte(this._queue, this._sales, this._dte);

  final DteQueueRepository _queue;
  final SaleRepository _sales;
  final DteGateway _dte;

  Future<RetryPendingDteResult> call(StoreId storeId) async {
    final pending = await _queue.listPending(storeId);
    var processed = 0;
    var failed = 0;

    for (final entry in pending) {
      final sale = await _sales.findById(storeId, entry.saleId);
      if (sale == null) {
        await _queue.remove(storeId, entry.saleId);
        failed++;
        continue;
      }
      if (sale.dteStatus == DteStatus.emitida) {
        await _queue.remove(storeId, entry.saleId);
        continue;
      }

      final updated = await emitSaleDte(sale, _dte, _queue);
      await _sales.save(updated);

      if (updated.dteStatus == DteStatus.emitida) {
        processed++;
      } else {
        failed++;
      }
    }

    return RetryPendingDteResult(processed: processed, failed: failed);
  }
}