import '../application/application.dart';
import '../domain/domain.dart';
import 'api_error.dart';
import 'api_result.dart';
import 'inventory_dtos.dart';

class InventoryService {
  factory InventoryService({
    StoreRepository? storeRepository,
    ProductRepository? productRepository,
    StockMovementRepository? stockMovementRepository,
    ShiftRepository? shiftRepository,
    SaleRepository? saleRepository,
    InventoryCloseRepository? inventoryCloseRepository,
    SessionProvider? sessionProvider,
  }) {
    final stores = storeRepository ?? InMemoryStoreRepository();
    final products = productRepository ?? InMemoryProductRepository();
    final movements =
        stockMovementRepository ?? InMemoryStockMovementRepository();
    final shifts = shiftRepository ?? InMemoryShiftRepository();
    final sales = saleRepository ?? InMemorySaleRepository();
    final inventoryCloses =
        inventoryCloseRepository ?? InMemoryInventoryCloseRepository();
    final sessions =
        sessionProvider ?? InMemorySessionProvider.supervisor();
    final adjustStock = AdjustStock(products, movements, sessions);
    return InventoryService._(
      stores,
      products,
      movements,
      sessions,
      adjustStock,
      GetInventoryClosePreview(shifts, products, sales, sessions),
      CloseInventory(
        shifts,
        products,
        sales,
        adjustStock,
        inventoryCloses,
        sessions,
      ),
    );
  }

  InventoryService._(
    StoreRepository stores,
    ProductRepository products,
    StockMovementRepository movements,
    SessionProvider sessions,
    AdjustStock adjustStock,
    GetInventoryClosePreview getPreview,
    CloseInventory closeInventory,
  )   : _getStock = GetProductStock(products),
        _adjustStock = adjustStock,
        _recordStockReceipt = RecordStockReceipt(
          stores,
          products,
          movements,
          sessions,
        ),
        _getInventoryClosePreview = getPreview,
        _closeInventory = closeInventory;

  final GetProductStock _getStock;
  final AdjustStock _adjustStock;
  final RecordStockReceipt _recordStockReceipt;
  final GetInventoryClosePreview _getInventoryClosePreview;
  final CloseInventory _closeInventory;

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

  Future<ApiResult<StockReceiptResponse>> recordStockReceipt(
    StoreId storeId,
    ProductId productId,
    StockReceiptRequest request,
  ) async {
    try {
      final result = await _recordStockReceipt(
        RecordStockReceiptInput(
          storeId: storeId,
          productId: productId,
          quantity: request.quantity,
          guideRef: request.guideRef,
          lotRef: request.lotRef,
          lotExpiry: request.lotExpiry != null && request.lotExpiry!.isNotEmpty
              ? DateTime.tryParse(request.lotExpiry!)
              : null,
        ),
      );
      return ApiSuccess(
        StockReceiptResponse(
          productId: result.productId,
          stock: result.stock,
          movementId: result.movementId,
          guideRef: result.guideRef,
          lotRef: result.lotRef,
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

  Future<ApiResult<InventoryClosePreviewResponse>> getInventoryClosePreview(
    StoreId storeId,
  ) async {
    try {
      final preview = await _getInventoryClosePreview(storeId);
      return ApiSuccess(
        InventoryClosePreviewResponse(
          shiftId: preview.shiftId,
          items: [
            for (final item in preview.items)
              InventoryClosePreviewItemResponse(
                productId: item.productId,
                name: item.name,
                systemStock: item.systemStock,
                unitsSoldInShift: item.unitsSoldInShift,
              ),
          ],
        ),
        statusCode: 200,
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

  Future<ApiResult<InventoryCloseSubmitResponse>> submitInventoryClose(
    StoreId storeId,
    InventoryCloseSubmitRequest request,
  ) async {
    try {
      final close = await _closeInventory(
        storeId,
        [
          for (final line in request.lines)
            CloseInventoryLineInput(
              productId: line.productId,
              countedQty: line.countedQty,
            ),
        ],
      );
      return ApiSuccess(
        InventoryCloseSubmitResponse(
          closeId: close.id,
          shiftId: close.shiftId,
          closedAt: close.createdAt.toUtc().toIso8601String(),
          lines: [
            for (final line in close.lines)
              InventoryCloseLineResponse(
                productId: line.productId,
                systemStock: line.systemStock,
                countedStock: line.countedStock,
                variance: line.variance,
                unitsSoldInShift: line.unitsSoldInShift,
              ),
          ],
        ),
        statusCode: 201,
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