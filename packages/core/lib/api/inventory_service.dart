import '../application/application.dart';
import '../domain/domain.dart';
import 'api_error.dart';
import 'api_result.dart';
import 'inventory_dtos.dart';

class InventoryService {
  factory InventoryService({
    ProductRepository? productRepository,
    StockMovementRepository? stockMovementRepository,
    SessionProvider? sessionProvider,
  }) {
    final products = productRepository ?? InMemoryProductRepository();
    final movements =
        stockMovementRepository ?? InMemoryStockMovementRepository();
    final sessions =
        sessionProvider ?? InMemorySessionProvider.supervisor();
    return InventoryService._(products, movements, sessions);
  }

  InventoryService._(
    ProductRepository products,
    StockMovementRepository movements,
    SessionProvider sessions,
  )   : _getStock = GetProductStock(products),
        _adjustStock = AdjustStock(products, movements, sessions);

  final GetProductStock _getStock;
  final AdjustStock _adjustStock;

  Future<ApiResult<StockResponse>> getProductStock(
    StoreId storeId,
    ProductId productId,
  ) async {
    try {
      final view = await _getStock(storeId, productId);
      return ApiSuccess(
        StockResponse(productId: view.productId, stock: view.stock),
        statusCode: 200,
      );
    } on NotFoundFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message, details: e.details),
        statusCode: 404,
      );
    }
  }

  Future<ApiResult<AdjustStockResponse>> adjustStock(
    StoreId storeId,
    ProductId productId,
    AdjustStockRequest request,
  ) async {
    try {
      final reason = StockAdjustmentReason.fromApi(request.reason);
      final result = await _adjustStock(
        AdjustStockInput(
          storeId: storeId,
          productId: productId,
          delta: request.delta,
          reason: reason,
          note: request.note,
        ),
      );
      return ApiSuccess(
        AdjustStockResponse(
          productId: result.productId,
          stock: result.stock,
          movementId: result.movementId,
        ),
        statusCode: 200,
      );
    } on ValidationFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 400,
      );
    } on NotFoundFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message, details: e.details),
        statusCode: 404,
      );
    } on CredentialFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 401,
      );
    } on ForbiddenFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 403,
      );
    } on SessionExpiredFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 401,
      );
    }
  }
}