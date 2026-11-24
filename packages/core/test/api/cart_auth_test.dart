import 'package:core/api/api.dart';
import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';

  Future<
      ({
        SaleService saleService,
        InMemorySessionProvider sessions,
        String cartId,
        String lineId,
      })> cartWithLine({
    InMemorySessionProvider? sessions,
  }) async {
    final carts = InMemoryCartRepository();
    final products = InMemoryProductRepository();
    final shifts = InMemoryShiftRepository();
    final shiftService = ShiftService(shiftRepository: shifts);
    final sessionProvider = sessions ?? InMemorySessionProvider.cajero();
    final productService = ProductService(repository: products);
    final saleService = SaleService(
      cartRepository: carts,
      productRepository: products,
      shiftRepository: shifts,
      sessionProvider: sessionProvider,
    );
    await shiftService.openShift(
      storeId,
      const OpenShiftRequest(openingCashClp: 0),
    );
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
    final add = await saleService.addLine(
      storeId,
      cartId,
      AddCartLineRequest(productId: productId, quantity: 2),
    );
    final lineId =
        (add as ApiSuccess<CartResponse>).data.lines.single.lineId;
    return (
      saleService: saleService,
      sessions: sessionProvider,
      cartId: cartId,
      lineId: lineId,
    );
  }

  test('SC-082-01 cajero actualiza cantidad → 200', () async {
    final ctx = await cartWithLine();
    final result = await ctx.saleService.updateLine(
      storeId,
      ctx.cartId,
      ctx.lineId,
      const UpdateCartLineRequest(quantity: 1),
    );
    expect(result, isA<ApiSuccess<CartResponse>>());
    expect((result as ApiSuccess<CartResponse>).data.totalClp, 500);
  });

  test('SC-082-02 cajero elimina línea → 204', () async {
    final ctx = await cartWithLine();
    final result = await ctx.saleService.removeLine(
      storeId,
      ctx.cartId,
      ctx.lineId,
    );
    expect(result, isA<ApiSuccess<void>>());
    expect((result as ApiSuccess<void>).statusCode, 204);
    final cart = await ctx.saleService.getCart(storeId, ctx.cartId);
    expect((cart as ApiSuccess<CartResponse>).data.lines, isEmpty);
  });

  test('SC-082-03 supervisor edita carrito', () async {
    final ctx = await cartWithLine(
      sessions: InMemorySessionProvider.supervisor(),
    );
    final update = await ctx.saleService.updateLine(
      storeId,
      ctx.cartId,
      ctx.lineId,
      const UpdateCartLineRequest(quantity: 1),
    );
    expect(update, isA<ApiSuccess<CartResponse>>());
  });

  test('SC-082-04 sin sesión → 401', () async {
    final ctx = await cartWithLine();
    ctx.sessions.clear();
    final result = await ctx.saleService.updateLine(
      storeId,
      ctx.cartId,
      ctx.lineId,
      const UpdateCartLineRequest(quantity: 1),
    );
    expect(result, isA<ApiFailure<CartResponse>>());
    expect((result as ApiFailure<CartResponse>).statusCode, 401);
  });

  test('SC-082-05 cantidad inválida → 400', () async {
    final ctx = await cartWithLine();
    final result = await ctx.saleService.updateLine(
      storeId,
      ctx.cartId,
      ctx.lineId,
      const UpdateCartLineRequest(quantity: 0),
    );
    expect(result, isA<ApiFailure<CartResponse>>());
    expect((result as ApiFailure<CartResponse>).error.code, 'VALIDACION');
  });
}