import 'package:core/api/api.dart';
import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

import '../support/collaborator_fixtures.dart';

void main() {
  const storeId = 't1';
  late InMemorySaleRepository sales;
  late InMemoryDteQueueRepository queue;
  late DteService dteService;
  late SaleService saleService;
  late ShiftService shiftService;
  late ProductService productService;
  late InMemoryProductRepository products;
  late InMemoryCartRepository carts;
  late InMemoryStockMovementRepository movements;
  late InMemoryShiftRepository shifts;
  late InMemoryCollaboratorRepository collaborators;

  setUp(() async {
    sales = InMemorySaleRepository();
    queue = InMemoryDteQueueRepository();
    products = InMemoryProductRepository();
    carts = InMemoryCartRepository();
    movements = InMemoryStockMovementRepository();
    shifts = InMemoryShiftRepository();
    collaborators = InMemoryCollaboratorRepository();
    await seedDefaultSeller(collaborators, storeId);
    dteService = DteService(
      queueRepository: queue,
      saleRepository: sales,
      dteGateway: FakeDteGateway(startingFolio: 5000),
    );
    shiftService = ShiftService(shiftRepository: shifts, saleRepository: sales);
    productService = ProductService(repository: products);
    saleService = SaleService(
      cartRepository: carts,
      productRepository: products,
      saleRepository: sales,
      stockMovementRepository: movements,
      shiftRepository: shifts,
      collaboratorRepository: collaborators,
      dteGateway: FakeDteGateway(mode: FakeDteMode.alwaysFailure),
      dteQueueRepository: queue,
    );
  });

  Future<String> checkoutPending() async {
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
    await saleService.checkout(
      storeId,
      cartId,
      const CheckoutRequest(
        sellerCode: 'V01',
        payments: [CheckoutPaymentDto(method: 'EFECTIVO', amountClp: 500)],
        changeClp: 0,
      ),
    );
    return cartId;
  }

  test('SC-051-02 API retry cola DTE', () async {
    await checkoutPending();
    final listBefore = await dteService.listQueue(storeId);
    final items =
        (listBefore as ApiSuccess<DteQueueListResponse>).data.items;
    expect(items, hasLength(1));

    final retry = await dteService.retryQueue(storeId);
    final body = (retry as ApiSuccess<DteRetryResponse>).data;
    expect(body.processed, 1);
    expect(body.failed, 0);

    final listAfter = await dteService.listQueue(storeId);
    expect(
      (listAfter as ApiSuccess<DteQueueListResponse>).data.items,
      isEmpty,
    );
  });
}