import '../domain/domain.dart';
import 'emit_credit_note_dte.dart';
import 'emit_sale_dte.dart';
import 'ports/credit_note_repository.dart';
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
  RetryPendingDte(
    this._queue,
    this._sales,
    this._creditNotes,
    this._dte,
  );

  final DteQueueRepository _queue;
  final SaleRepository _sales;
  final CreditNoteRepository _creditNotes;
  final DteGateway _dte;

  Future<RetryPendingDteResult> call(StoreId storeId) async {
    final pending = await _queue.listPending(storeId);
    var processed = 0;
    var failed = 0;

    for (final entry in pending) {
      if (entry.documentType == DteDocumentType.notaCredito) {
        final note = await _creditNotes.findById(storeId, entry.documentId);
        if (note == null) {
          await _queue.remove(storeId, entry.documentId);
          failed++;
          continue;
        }
        if (note.dteStatus == DteStatus.emitida) {
          await _queue.remove(storeId, entry.documentId);
          continue;
        }
        final sale = await _sales.findById(storeId, entry.saleId);
        if (sale == null) {
          await _queue.remove(storeId, entry.documentId);
          failed++;
          continue;
        }
        final updated = await emitCreditNoteDte(note, sale, _dte, _queue);
        await _creditNotes.save(updated);
        if (updated.dteStatus == DteStatus.emitida) {
          processed++;
        } else {
          failed++;
        }
        continue;
      }

      final sale = await _sales.findById(storeId, entry.saleId);
      if (sale == null) {
        await _queue.remove(storeId, entry.documentId);
        failed++;
        continue;
      }
      if (sale.dteStatus == DteStatus.emitida) {
        await _queue.remove(storeId, entry.documentId);
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