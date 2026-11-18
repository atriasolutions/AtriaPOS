import '../application/application.dart';
import '../domain/domain.dart';
import 'api_result.dart';
import 'dte_dtos.dart';

class DteService {
  factory DteService({
    DteQueueRepository? queueRepository,
    SaleRepository? saleRepository,
    DteGateway? dteGateway,
  }) {
    final queue = queueRepository ?? InMemoryDteQueueRepository();
    final sales = saleRepository ?? InMemorySaleRepository();
    final dte = dteGateway ?? FakeDteGateway();
    return DteService._(queue, sales, dte);
  }

  DteService._(
    DteQueueRepository queue,
    SaleRepository sales,
    DteGateway dte,
  )   : _listPending = ListPendingDte(queue),
        _retry = RetryPendingDte(queue, sales, dte);

  final ListPendingDte _listPending;
  final RetryPendingDte _retry;

  Future<ApiResult<DteQueueListResponse>> listQueue(StoreId storeId) async {
    final entries = await _listPending(storeId);
    return ApiSuccess(
      DteQueueListResponse(
        items: entries
            .map(
              (e) => DteQueueEntryResponse(
                saleId: e.saleId,
                attempts: e.attempts,
                lastError: e.lastError,
                createdAt: e.createdAt.toUtc().toIso8601String(),
              ),
            )
            .toList(),
      ),
      statusCode: 200,
    );
  }

  Future<ApiResult<DteRetryResponse>> retryQueue(StoreId storeId) async {
    final result = await _retry(storeId);
    return ApiSuccess(
      DteRetryResponse(
        processed: result.processed,
        failed: result.failed,
      ),
      statusCode: 200,
    );
  }
}