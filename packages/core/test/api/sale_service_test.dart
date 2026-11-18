import 'package:core/api/api.dart';
import 'package:core/application/application.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';
  late ProductRepository products;
  late CartRepository carts;
  late SaleRepository sales;
  late StockMovementRepository movements;
  late ShiftRepository shifts;
  late ShiftService shiftService;
  late ProductService productService;
  late SaleService saleService;

  setUp(() {
    products = InMemoryProductRepository();
    carts = InMemoryCartRepository();
    sales = InMemorySaleRepository();
    movements = InMemoryStockMovementRepository();
    shifts = InMemoryShiftRepository();
    shiftService = ShiftService(shiftRepository: shifts, saleRepository: sales);
    productService = ProductService(repository: products);
    saleService = SaleService(
      cartRepository: carts,
      productRepository: products,
      saleRepository: sales,
      stockMovementRepository: movements,
      shiftRepository: shifts,
    );
  });

  Future<void> openTurn() async {
    await shiftService.openShift(
      storeId,
      const OpenShiftRequest(openingCashClp: 50000),
    );
  }

  Future<String> setupPanCart() async {
    await openTurn();
    await productService.createProduct(
      storeId,
      const CreateProductRequest(
        name: 'Pan',
        salePriceClp: 500,
        initialStock: 10,
      ),
    );
    final create = await saleService.createCart(storeId);
    final cartId = (create as ApiSuccess<CreateCartResponse>).data.cartId;
    final search = await productService.searchProducts(storeId, 'Pan');
    final productId =
        (search as ApiSuccess<SearchProductsResponse>).data.items.first.id;
    await saleService.addLine(
      storeId,
      cartId,
      AddCartLineRequest(productId: productId, quantity: 2),
    );
    return cartId;
  }

  test('checkout SC-031-02 carro vacío → 400 VALIDACION', () async {
    await openTurn();
    final create = await saleService.createCart(storeId);
    final cartId = (create as ApiSuccess<CreateCartResponse>).data.cartId;
    final result = await saleService.checkout(
      storeId,
      cartId,
      const CheckoutRequest(
        payments: [CheckoutPaymentDto(method: 'EFECTIVO', amountClp: 100)],
        changeClp: 0,
      ),
    );
    expect(result, isA<ApiFailure<CheckoutResponse>>());
    expect((result as ApiFailure<CheckoutResponse>).error.code, 'VALIDACION');
  });

  test('checkout SC-031-03 stock insuficiente → 409', () async {
    await openTurn();
    await productService.createProduct(
      storeId,
      const CreateProductRequest(
        name: 'Pan',
        salePriceClp: 500,
        initialStock: 1,
      ),
    );
    final create = await saleService.createCart(storeId);
    final cartId = (create as ApiSuccess<CreateCartResponse>).data.cartId;
    final search = await productService.searchProducts(storeId, 'Pan');
    final productId =
        (search as ApiSuccess<SearchProductsResponse>).data.items.first.id;
    await saleService.addLine(
      storeId,
      cartId,
      AddCartLineRequest(productId: productId, quantity: 2),
    );
    final result = await saleService.checkout(
      storeId,
      cartId,
      const CheckoutRequest(
        payments: [CheckoutPaymentDto(method: 'EFECTIVO', amountClp: 1000)],
        changeClp: 0,
      ),
    );
    expect(result, isA<ApiFailure<CheckoutResponse>>());
    final failure = result as ApiFailure<CheckoutResponse>;
    expect(failure.statusCode, 409);
    expect(failure.error.code, 'STOCK_INSUFICIENTE');
  });

  test('checkout SC-031-04 pago insuficiente → 400', () async {
    final cartId = await setupPanCart();
    final result = await saleService.checkout(
      storeId,
      cartId,
      const CheckoutRequest(
        payments: [CheckoutPaymentDto(method: 'EFECTIVO', amountClp: 500)],
        changeClp: 0,
      ),
    );
    expect(result, isA<ApiFailure<CheckoutResponse>>());
    expect((result as ApiFailure<CheckoutResponse>).error.code, 'VALIDACION');
  });

  test('checkout SC-031-05 sin turno → 403 TURNO_CERRADO', () async {
    final cartId = await setupPanCart();
    final noShiftSales = InMemorySaleRepository();
    final noShiftService = SaleService(
      cartRepository: carts,
      productRepository: products,
      saleRepository: noShiftSales,
      stockMovementRepository: movements,
      shiftRepository: InMemoryShiftRepository(),
    );
    final result = await noShiftService.checkout(
      storeId,
      cartId,
      const CheckoutRequest(
        payments: [CheckoutPaymentDto(method: 'EFECTIVO', amountClp: 1000)],
        changeClp: 0,
      ),
    );
    expect(result, isA<ApiFailure<CheckoutResponse>>());
    final failure = result as ApiFailure<CheckoutResponse>;
    expect(failure.statusCode, 403);
    expect(failure.error.code, 'TURNO_CERRADO');
  });

  test('checkout SC-031-01', () async {
    final cartId = await setupPanCart();
    final result = await saleService.checkout(
      storeId,
      cartId,
      const CheckoutRequest(
        payments: [CheckoutPaymentDto(method: 'EFECTIVO', amountClp: 1000)],
        changeClp: 0,
      ),
    );
    expect(result, isA<ApiSuccess<CheckoutResponse>>());
    final success = result as ApiSuccess<CheckoutResponse>;
    expect(success.data.totalClp, 1000);
    expect(success.data.dteStatus, 'EMITIDA');
    expect(success.data.folio, isNotNull);
    final search = await productService.searchProducts(storeId, 'Pan');
    final stock =
        (search as ApiSuccess<SearchProductsResponse>).data.items.first.stock;
    expect(stock, 8);
  });
}