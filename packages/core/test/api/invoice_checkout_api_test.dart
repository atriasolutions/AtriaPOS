import 'package:core/api/api.dart';
import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

import '../support/collaborator_fixtures.dart';
import '../support/invoice_receiver_fixture.dart';

void main() {
  const storeId = 't1';
  late SaleService saleService;
  late ShiftService shiftService;
  late ProductService productService;
  late InMemoryStoreRepository stores;
  late String cartId;

  setUp(() async {
    stores = InMemoryStoreRepository();
    await stores.save(
      Store.create(
        id: storeId,
        rutRaw: '12.345.678-5',
        legalName: 'Tienda Demo',
        businessLine: 'Retail',
      ),
    );
    final products = InMemoryProductRepository();
    final carts = InMemoryCartRepository();
    final sales = InMemorySaleRepository();
    final movements = InMemoryStockMovementRepository();
    final shifts = InMemoryShiftRepository();
    final collaborators = InMemoryCollaboratorRepository();
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
      storeRepository: stores,
    );
    await shiftService.openShift(storeId, const OpenShiftRequest(openingCashClp: 0));
    final product = await productService.createProduct(
      storeId,
      const CreateProductRequest(
        name: 'Pan',
        salePriceClp: 500,
        initialStock: 5,
      ),
    );
    final productId = (product as ApiSuccess<ProductResponse>).data.id;
    final cart = await saleService.createCart(storeId);
    cartId = (cart as ApiSuccess<CreateCartResponse>).data.cartId;
    await saleService.addLine(
      storeId,
      cartId,
      AddCartLineRequest(productId: productId, quantity: 2),
    );
  });

  test('SC-093-01 API checkout factura 201', () async {
    final result = await saleService.checkout(
      storeId,
      cartId,
      CheckoutRequest(
        sellerCode: 'V01',
        payments: const [CheckoutPaymentDto(method: 'EFECTIVO', amountClp: 1000)],
        changeClp: 0,
        documentType: 'FACTURA',
        invoiceReceiver: invoiceReceiverDto(),
      ),
    );
    expect(result, isA<ApiSuccess<CheckoutResponse>>());
    final data = (result as ApiSuccess<CheckoutResponse>).data;
    expect(data.documentType, DteDocumentType.factura);
    expect(data.dteStatus, 'EMITIDA');
  });

  test('SC-093-02 API RUT inválido 400', () async {
    final result = await saleService.checkout(
      storeId,
      cartId,
      CheckoutRequest(
        sellerCode: 'V01',
        payments: const [CheckoutPaymentDto(method: 'EFECTIVO', amountClp: 1000)],
        changeClp: 0,
        documentType: 'FACTURA',
        invoiceReceiver: invoiceReceiverDto(rut: '12.345.678-0'),
      ),
    );
    expect(result, isA<ApiFailure<CheckoutResponse>>());
    expect((result as ApiFailure).error.code, 'VALIDACION');
  });
}