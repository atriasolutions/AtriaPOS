import 'package:core/api/api.dart';
import 'package:core/application/application.dart';
import 'package:test/test.dart';

import '../support/collaborator_fixtures.dart';

void main() {
  const storeId = 't1';
  late CollaboratorRepository collaborators;
  late SaleService saleService;
  late ShiftService shiftService;
  late ProductService productService;
  late CartRepository carts;
  late ProductRepository products;
  late SaleRepository sales;
  late StockMovementRepository movements;
  late ShiftRepository shifts;

  setUp(() async {
    products = InMemoryProductRepository();
    carts = InMemoryCartRepository();
    sales = InMemorySaleRepository();
    movements = InMemoryStockMovementRepository();
    shifts = InMemoryShiftRepository();
    collaborators = InMemoryCollaboratorRepository();
    await seedDefaultSeller(collaborators, storeId);
    shiftService = ShiftService(shiftRepository: shifts, saleRepository: sales);
    productService = ProductService(repository: products);
    saleService = SaleService(
      cartRepository: carts,
      productRepository: products,
      saleRepository: sales,
      stockMovementRepository: movements,
      shiftRepository: shifts,
      collaboratorRepository: collaborators,
    );
  });

  Future<String> cartWithPan() async {
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
    await saleService.addLine(
      storeId,
      cartId,
      AddCartLineRequest(productId: productId, quantity: 1),
    );
    return cartId;
  }

  test('SC-144-04 checkout API sin vendedor responde 201', () async {
    final cartId = await cartWithPan();
    final result = await saleService.checkout(
      storeId,
      cartId,
      const CheckoutRequest(
        sellerCode: '',
        payments: [CheckoutPaymentDto(method: 'EFECTIVO', amountClp: 500)],
        changeClp: 0,
      ),
    );
    expect(result, isA<ApiSuccess<CheckoutResponse>>());
    expect((result as ApiSuccess<CheckoutResponse>).data.sellerCode, '');
  });

  test('SC-084-01 checkout API devuelve sellerCode', () async {
    final cartId = await cartWithPan();
    final result = await saleService.checkout(
      storeId,
      cartId,
      const CheckoutRequest(
        sellerCode: 'V01',
        payments: [CheckoutPaymentDto(method: 'EFECTIVO', amountClp: 500)],
        changeClp: 0,
      ),
    );
    expect(result, isA<ApiSuccess<CheckoutResponse>>());
    expect((result as ApiSuccess<CheckoutResponse>).data.sellerCode, '');
  });

  test('SC-084-04 listActiveForSale cajero → 200', () async {
    final service = CollaboratorService(
      repository: collaborators,
      sessionProvider: InMemorySessionProvider.cajero(),
    );
    final result = await service.listActiveForSale(storeId);
    expect(result, isA<ApiSuccess<ListActiveCollaboratorsResponse>>());
    final items =
        (result as ApiSuccess<ListActiveCollaboratorsResponse>).data.items;
    expect(items, hasLength(1));
    expect(items.single.sellerCode, 'V01');
  });
}