import '../domain/domain.dart';
import 'ports/dte_gateway.dart';
import 'ports/dte_queue_repository.dart';
import 'ports/trusted_clock.dart';

Future<CreditNote> emitCreditNoteDte(
  CreditNote note,
  Sale referencedSale,
  DteGateway gateway,
  DteQueueRepository queue, [
  TrustedClock? clock,
]) async {
  final trustedClock = clock ?? MutableTrustedClock();
  if (note.dteStatus == DteStatus.emitida) {
    return note;
  }

  final result = await gateway.emitCreditNote(
    DteCreditNoteEmitRequest(
      creditNoteId: note.id,
      storeId: note.storeId,
      referencedSaleId: referencedSale.id,
      referencedSaleFolio: note.referencedSaleFolio,
      referencedDocumentType: note.referencedDocumentType,
      referencedSaleCreatedAt: referencedSale.createdAt,
      totalClp: note.totalClp,
      lines: [
        for (final line in note.lines)
          DteCreditNoteLineRequest(
            productName: line.productName,
            quantity: line.quantity,
            unitPriceClp: line.unitPriceClp,
          ),
      ],
    ),
  );

  switch (result.status) {
    case DteStatus.emitida:
      await queue.remove(note.storeId, note.id);
      return note.withDte(
        dteStatus: DteStatus.emitida,
        folio: result.folio,
        pdfUrl: result.pdfUrl,
      );
    case DteStatus.rechazadaSii:
      await queue.remove(note.storeId, note.id);
      return note.withDte(dteStatus: DteStatus.rechazadaSii);
    case DteStatus.pendienteDte:
      final pending = (await queue.listPending(note.storeId))
          .where(
            (e) =>
                e.documentId == note.id &&
                e.documentType == DteDocumentType.notaCredito,
          )
          .toList();
      if (pending.isEmpty) {
        await queue.enqueue(
          DteQueueEntry(
            saleId: referencedSale.id,
            storeId: note.storeId,
            documentType: DteDocumentType.notaCredito,
            documentId: note.id,
            attempts: 0,
            createdAt: trustedClock.now(),
          ),
        );
      } else {
        await queue.save(pending.first.withAttempt(result.errorMessage));
      }
      return note.withDte(dteStatus: DteStatus.pendienteDte);
  }
}