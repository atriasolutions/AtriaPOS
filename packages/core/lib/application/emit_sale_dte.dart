import '../domain/domain.dart';
import 'ports/dte_gateway.dart';
import 'ports/dte_queue_repository.dart';
import 'ports/trusted_clock.dart';

Future<Sale> emitSaleDte(
  Sale sale,
  DteGateway gateway,
  DteQueueRepository queue, [
  TrustedClock? clock,
]) async {
  final trustedClock = clock ?? MutableTrustedClock();
  if (sale.dteStatus == DteStatus.emitida) {
    return sale;
  }

  final result = await gateway.emit(DteEmitRequest.fromSale(sale));

  switch (result.status) {
    case DteStatus.emitida:
      await queue.remove(sale.storeId, sale.id);
      return sale.withDte(
        dteStatus: DteStatus.emitida,
        folio: result.folio,
        pdfUrl: result.pdfUrl,
      );
    case DteStatus.rechazadaSii:
      await queue.remove(sale.storeId, sale.id);
      return sale.withDte(dteStatus: DteStatus.rechazadaSii);
    case DteStatus.pendienteDte:
      final existing = (await queue.listPending(sale.storeId))
          .where((e) => e.saleId == sale.id)
          .toList();
      if (existing.isEmpty) {
        await queue.enqueue(
          DteQueueEntry(
            saleId: sale.id,
            storeId: sale.storeId,
            attempts: 0,
            createdAt: trustedClock.now(),
          ),
        );
      } else {
        await queue.save(
          existing.first.withAttempt(result.errorMessage),
        );
      }
      return sale.withDte(dteStatus: DteStatus.pendienteDte);
  }
}