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
    CollaboratorRepository? collaboratorRepository,
    StoreRepository? storeRepository,
    ProductExchangeRepository? productExchangeRepository,
    CreditNoteRepository? creditNoteRepository,
    TrustedClock? clock,
  }) {
    final carts = cartRepository ?? InMemoryCartRepository();
    final trustedClock = clock ?? MutableTrustedClock();
    final products = productRepository ?? InMemoryProductRepository();
    final sales = saleRepository ?? InMemorySaleRepository();
    final exchanges =
        productExchangeRepository ?? InMemoryProductExchangeRepository();
    final creditNotes =
        creditNoteRepository ?? InMemoryCreditNoteRepository();
    final movements =
        stockMovementRepository ?? InMemoryStockMovementRepository();
    final shifts = shiftRepository ?? InMemoryShiftRepository();
    final collaborators =
        collaboratorRepository ?? InMemoryCollaboratorRepository();
    final stores = storeRepository ?? InMemoryStoreRepository();
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
      collaborators,
      stores,
      dte,
      dteQueue,
      sessions,
      trustedClock,
      exchanges,
      creditNotes,
    );
  }

  SaleService._(
    CartRepository carts,
    ProductRepository products,
    SaleRepository sales,
    StockMovementRepository movements,
    ShiftRepository shifts,
    CollaboratorRepository collaborators,
    StoreRepository stores,
    DteGateway dte,
    DteQueueRepository dteQueue,
    SessionProvider sessions,
    TrustedClock clock,
    ProductExchangeRepository exchanges,
    CreditNoteRepository creditNotes,
  )   : _createCart = CreateCart(carts, shifts, sessions),
        _addLine = AddCartLine(carts, products, sessions),
        _updateLine = UpdateCartLineQuantity(carts, sessions),
        _removeLine = RemoveCartLine(carts, sessions),
        _getCart = GetCart(carts, sessions),
        _checkout = ConfirmCheckout(
          carts,
          products,
          sales,
          movements,
          shifts,
          collaborators,
          stores,
          dte,
          dteQueue,
          sessions,
          clock,
        ),
        _voidSale = VoidSale(
          sales,
          products,
          movements,
          shifts,
          dteQueue,
          sessions,
        ),
        _listShiftSales = ListShiftSales(sales, shifts, sessions),
        _registerProductExchange = RegisterProductExchange(
          sales,
          products,
          movements,
          shifts,
          exchanges,
          creditNotes,
          sessions,
          clock,
        ),
        _getSaleProductExchangeContext = GetSaleProductExchangeContext(
          sales,
          shifts,
          exchanges,
          sessions,
        ),
        _issueCreditNote = IssueCreditNote(
          sales,
          products,
          movements,
          shifts,
          creditNotes,
          dte,
          dteQueue,
          sessions,
          clock,
        );

  final CreateCart _createCart;
  final AddCartLine _addLine;
  final UpdateCartLineQuantity _updateLine;
  final RemoveCartLine _removeLine;
  final GetCart _getCart;
  final ConfirmCheckout _checkout;
  final VoidSale _voidSale;
  final ListShiftSales _listShiftSales;
  final RegisterProductExchange _registerProductExchange;
  final GetSaleProductExchangeContext _getSaleProductExchangeContext;
  final IssueCreditNote _issueCreditNote;

  Future<ApiResult<CreateCartResponse>> createCart(StoreId storeId) async {
    try {
      final cart = await _createCart(storeId);
      return ApiSuccess(
        CreateCartResponse(cartId: cart.id),
        statusCode: 201,
      );
    } on CredentialFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 401,
      );
    } on SessionExpiredFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 401,
      );
    } on ForbiddenFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 403,
      );
    }
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
    } on CredentialFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 401,
      );
    } on SessionExpiredFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 401,
      );
    } on ForbiddenFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 403,
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
    } on CredentialFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 401,
      );
    } on SessionExpiredFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 401,
      );
    } on ForbiddenFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 403,
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
    } on CredentialFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 401,
      );
    } on SessionExpiredFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 401,
      );
    } on ForbiddenFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 403,
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
    } on CredentialFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 401,
      );
    } on SessionExpiredFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 401,
      );
    } on ForbiddenFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 403,
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
          sellerCode: request.sellerCode,
          payments: payments,
          changeClp: request.changeClp,
        ),
      );
      return ApiSuccess(
        CheckoutResponse(
          saleId: result.saleId,
          totalClp: result.totalClp,
          sellerCode: result.sellerCode,
          dteStatus: result.dteStatus.apiValue,
          createdAt: result.createdAt.toUtc().toIso8601String(),
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
                  sellerCode: i.sellerCode,
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

  Future<ApiResult<SaleProductExchangeContextResponse>>
      getSaleProductExchangeContext(StoreId storeId, SaleId saleId) async {
    try {
      final ctx = await _getSaleProductExchangeContext(storeId, saleId);
      return ApiSuccess(
        SaleProductExchangeContextResponse(
          saleId: ctx.saleId,
          status: ctx.status.apiValue,
          dteStatus: ctx.dteStatus.apiValue,
          lines: [
            for (final line in ctx.lines)
              SaleProductExchangeLineDto(
                productId: line.productId,
                productName: line.productName,
                quantity: line.quantity,
                unitPriceClp: line.unitPriceClp,
                returnedQuantity: line.returnedQuantity,
                availableQuantity: line.availableQuantity,
              ),
          ],
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

  Future<ApiResult<IssueCreditNoteResponse>> issueCreditNote(
    StoreId storeId,
    SaleId saleId,
    IssueCreditNoteRequest request,
  ) async {
    try {
      final result = await _issueCreditNote(
        IssueCreditNoteInput(
          storeId: storeId,
          saleId: saleId,
          lines: [
            for (final line in request.lines)
              IssueCreditNoteLineInput(
                productId: line.productId,
                quantity: line.quantity,
              ),
          ],
        ),
      );
      final note = result.creditNote;
      return ApiSuccess(
        IssueCreditNoteResponse(
          creditNoteId: note.id,
          folio: note.folio,
          dteStatus: note.dteStatus.apiValue,
          creditedClp: note.totalClp,
          saleStatus: result.sale.status.apiValue,
          returnedLines: [
            for (final line in result.returnedLines)
              IssueCreditNoteReturnedLineDto(
                productId: line.productId,
                quantity: line.quantity,
                stockAfter: line.stockAfter,
              ),
          ],
        ),
        statusCode: 201,
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

  Future<ApiResult<RegisterProductExchangeResponse>> registerProductExchange(
    StoreId storeId,
    SaleId saleId,
    RegisterProductExchangeRequest request,
  ) async {
    try {
      ProductExchangePaymentInput? paymentInput;
      final dto = request.differencePayment;
      if (dto != null) {
        paymentInput = ProductExchangePaymentInput(
          method: PaymentMethod.fromApi(dto.method),
          amountClp: dto.amountClp,
        );
      }
      final result = await _registerProductExchange(
        RegisterProductExchangeInput(
          storeId: storeId,
          saleId: saleId,
          returnProductId: request.returnProductId,
          returnQuantity: request.returnQuantity,
          newProductId: request.newProductId,
          newQuantity: request.newQuantity,
          differencePayment: paymentInput,
          creditNoteId: request.creditNoteId,
        ),
      );
      final exchange = result.exchange;
      return ApiSuccess(
        RegisterProductExchangeResponse(
          exchangeId: exchange.id,
          newSaleId: exchange.newSaleId,
          creditClp: exchange.creditClp,
          chargeClp: exchange.chargeClp,
          differenceClp: exchange.differenceClp,
          returnProductStock: result.returnProductStock,
          newProductStock: result.newProductStock,
          creditNoteId: exchange.creditNoteId,
        ),
        statusCode: 201,
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