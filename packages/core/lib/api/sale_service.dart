import '../application/application.dart';
import '../domain/domain.dart';
import 'api_error.dart';
import 'api_result.dart';
import 'sale_dtos.dart';

class SaleService {
  factory SaleService({
    CartRepository? cartRepository,
    ProductRepository? productRepository,
    SaleRepository? saleRepository,
    StockMovementRepository? stockMovementRepository,
    ShiftRepository? shiftRepository,
    DteGateway? dteGateway,
    DteQueueRepository? dteQueueRepository,
    SessionProvider? sessionProvider,
  }) {
    final carts = cartRepository ?? InMemoryCartRepository();
    final products = productRepository ?? InMemoryProductRepository();
    final sales = saleRepository ?? InMemorySaleRepository();
    final movements =
        stockMovementRepository ?? InMemoryStockMovementRepository();
    final shifts = shiftRepository ?? InMemoryShiftRepository();
    final dte = dteGateway ?? FakeDteGateway();
    final dteQueue = dteQueueRepository ?? InMemoryDteQueueRepository();
    final sessions =
        sessionProvider ?? InMemorySessionProvider.supervisor();
    return SaleService._(
      carts,
      products,
      sales,
      movements,
      shifts,
      dte,
      dteQueue,
      sessions,
    );
  }

  SaleService._(
    CartRepository carts,
    ProductRepository products,
    SaleRepository sales,
    StockMovementRepository movements,
    ShiftRepository shifts,
    DteGateway dte,
    DteQueueRepository dteQueue,
    SessionProvider sessions,
  )   : _createCart = CreateCart(carts, shifts),
        _addLine = AddCartLine(carts, products),
        _updateLine = UpdateCartLineQuantity(carts),
        _removeLine = RemoveCartLine(carts),
        _getCart = GetCart(carts),
        _checkout = ConfirmCheckout(
          carts,
          products,
          sales,
          movements,
          shifts,
          dte,
          dteQueue,
        ),
        _voidSale = VoidSale(
          sales,
          products,
          movements,
          shifts,
          dteQueue,
          sessions,
        ),
        _listShiftSales = ListShiftSales(sales, shifts, sessions);

  final CreateCart _createCart;
  final AddCartLine _addLine;
  final UpdateCartLineQuantity _updateLine;
  final RemoveCartLine _removeLine;
  final GetCart _getCart;
  final ConfirmCheckout _checkout;
  final VoidSale _voidSale;
  final ListShiftSales _listShiftSales;

  Future<ApiResult<CreateCartResponse>> createCart(StoreId storeId) async {
    final cart = await _createCart(storeId);
    return ApiSuccess(
      CreateCartResponse(cartId: cart.id),
      statusCode: 201,
    );
  }

  Future<ApiResult<CartResponse>> getCart(StoreId storeId, CartId cartId) async {
    try {
      final view = await _getCart(storeId, cartId);
      return ApiSuccess(_toCartResponse(view), statusCode: 200);
    } on NotFoundFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message, details: e.details),
        statusCode: 404,
      );
    }
  }

  Future<ApiResult<CartResponse>> addLine(
    StoreId storeId,
    CartId cartId,
    AddCartLineRequest request,
  ) async {
    try {
      await _addLine(
        AddCartLineInput(
          storeId: storeId,
          cartId: cartId,
          productId: request.productId,
          quantity: request.quantity,
        ),
      );
      final view = await _getCart(storeId, cartId);
      return ApiSuccess(_toCartResponse(view), statusCode: 200);
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
    }
  }

  Future<ApiResult<CartResponse>> updateLine(
    StoreId storeId,
    CartId cartId,
    CartLineId lineId,
    UpdateCartLineRequest request,
  ) async {
    try {
      await _updateLine(storeId, cartId, lineId, request.quantity);
      final view = await _getCart(storeId, cartId);
      return ApiSuccess(_toCartResponse(view), statusCode: 200);
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
    }
  }

  Future<ApiResult<void>> removeLine(
    StoreId storeId,
    CartId cartId,
    CartLineId lineId,
  ) async {
    try {
      await _removeLine(storeId, cartId, lineId);
      return ApiSuccess<void>(null, statusCode: 204);
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
    }
  }

  Future<ApiResult<CheckoutResponse>> checkout(
    StoreId storeId,
    CartId cartId,
    CheckoutRequest request,
  ) async {
    try {
      final payments = request.payments
          .map(
            (p) => CheckoutPaymentInput(
              method: PaymentMethod.fromApi(p.method),
              amountClp: p.amountClp,
            ),
          )
          .toList();
      final result = await _checkout(
        ConfirmCheckoutInput(
          storeId: storeId,
          cartId: cartId,
          payments: payments,
          changeClp: request.changeClp,
        ),
      );
      return ApiSuccess(
        CheckoutResponse(
          saleId: result.saleId,
          totalClp: result.totalClp,
          dteStatus: result.dteStatus.apiValue,
          folio: result.folio,
          pdfUrl: result.pdfUrl,
        ),
        statusCode: 201,
      );
    } on ValidationFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 400,
      );
    } on InsufficientStockFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message, details: e.details),
        statusCode: 409,
      );
    } on TurnClosedFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 403,
      );
    } on NotFoundFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message, details: e.details),
        statusCode: 404,
      );
    }
  }

  Future<ApiResult<ListShiftSalesResponse>> listShiftSales(StoreId storeId) async {
    try {
      final items = await _listShiftSales(storeId);
      return ApiSuccess(
        ListShiftSalesResponse(
          items: items
              .map(
                (i) => ShiftSaleItemResponse(
                  saleId: i.saleId,
                  totalClp: i.totalClp,
                  status: i.status.apiValue,
                  dteStatus: i.dteStatus.apiValue,
                  folio: i.folio,
                ),
              )
              .toList(),
        ),
        statusCode: 200,
      );
    } on ForbiddenFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 403,
      );
    } on TurnClosedFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 403,
      );
    }
  }

  Future<ApiResult<VoidSaleResponse>> voidSale(
    StoreId storeId,
    SaleId saleId,
  ) async {
    try {
      final sale = await _voidSale(storeId, saleId);
      return ApiSuccess(
        VoidSaleResponse(
          saleId: sale.id,
          status: sale.status.apiValue,
        ),
        statusCode: 200,
      );
    } on ForbiddenFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 403,
      );
    } on ValidationFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 400,
      );
    } on ConflictFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message, details: e.details),
        statusCode: 409,
      );
    } on TurnClosedFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 403,
      );
    } on NotFoundFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message, details: e.details),
        statusCode: 404,
      );
    }
  }

  CartResponse _toCartResponse(CartView view) => CartResponse(
        cartId: view.cart.id,
        totalClp: view.totalClp,
        lines: view.cart.lines
            .map(
              (l) => CartLineResponse(
                lineId: l.lineId,
                productId: l.productId,
                name: l.productName,
                quantity: l.quantity,
                unitPriceClp: l.unitPriceClp,
              ),
            )
            .toList(),
      );
}