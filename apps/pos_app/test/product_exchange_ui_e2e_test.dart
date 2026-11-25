import 'package:core/api/api.dart';
import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app/config/store_config.dart';
import 'package:pos_app/di/pos_composition.dart';
import 'package:pos_app/screens/product_exchange_screen.dart';

Future<String> _checkoutSale(
  PosComposition composition, {
  required String productId,
  int quantity = 2,
  int unitPrice = 500,
}) async {
  final cart = await composition.saleService.createCart(kDemoStoreId);
  final cartId = (cart as ApiSuccess<CreateCartResponse>).data.cartId;
  await composition.saleService.addLine(
    kDemoStoreId,
    cartId,
    AddCartLineRequest(productId: productId, quantity: quantity),
  );
  final total = unitPrice * quantity;
  final checkout = await composition.saleService.checkout(
    kDemoStoreId,
    cartId,
    CheckoutRequest(
      sellerCode: 'V01',
      payments: [CheckoutPaymentDto(method: 'EFECTIVO', amountClp: total)],
      changeClp: 0,
    ),
  );
  return (checkout as ApiSuccess<CheckoutResponse>).data.saleId;
}

Future<void> _seedSupervisorShift(PosComposition composition) async {
  await composition.ensureDemoStore();
  await composition.ensureDemoUsers();
  await composition.ensureDemoSeller();
  await composition.authService.login(
    kDemoStoreId,
    const LoginRequest(username: 'usr_supervisor', pin: PosComposition.demoPin),
  );
  await composition.shiftService.openShift(
    kDemoStoreId,
    const OpenShiftRequest(openingCashClp: 5000),
  );
}

Future<(String panId, String otherId)> _seedTwoProducts(
  PosComposition composition, {
  int panPrice = 500,
  int otherPrice = 500,
}) async {
  final pan = await composition.productService.createProduct(
    kDemoStoreId,
    CreateProductRequest(
      name: 'Pan Cambio',
      salePriceClp: panPrice,
      initialStock: 20,
    ),
  );
  final other = await composition.productService.createProduct(
    kDemoStoreId,
    CreateProductRequest(
      name: 'Galletas Cambio',
      salePriceClp: otherPrice,
      initialStock: 20,
    ),
  );
  return (
    (pan as ApiSuccess<ProductResponse>).data.id,
    (other as ApiSuccess<ProductResponse>).data.id,
  );
}

Future<void> _runExchangeFlow(
  WidgetTester tester,
  PosComposition composition,
  String saleId,
  String returnProductId,
  String newProductId,
  String searchQuery,
) async {
  await tester.pumpWidget(
    MaterialApp(
      home: ProductExchangeScreen(composition: composition),
    ),
  );
  await tester.pumpAndSettle();

  await tester.enterText(
    find.byKey(const Key('product_exchange_sale_id_field')),
    saleId,
  );
  await tester.tap(find.byKey(const Key('product_exchange_load_button')));
  await tester.pumpAndSettle();

  await tester.tap(find.byKey(Key('product_exchange_return_$returnProductId')));
  await tester.pumpAndSettle();

  await tester.enterText(
    find.byKey(const Key('product_exchange_return_qty_field')),
    '1',
  );
  await tester.enterText(
    find.byKey(const Key('product_exchange_search_field')),
    searchQuery,
  );
  await tester.tap(find.byIcon(Icons.search));
  await tester.pumpAndSettle();

  await tester.tap(find.byKey(Key('product_exchange_pick_$newProductId')));
  await tester.pumpAndSettle();

  await tester.enterText(
    find.byKey(const Key('product_exchange_new_qty_field')),
    '1',
  );
  await tester.pumpAndSettle();

  await tester.ensureVisible(
    find.byKey(const Key('product_exchange_submit_button')),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('SC-091-UI-01 cambio mismo valor desde UI', (tester) async {
    final composition = PosComposition.memory(
      dteGateway: FakeDteGateway(mode: FakeDteMode.rechazadaSii),
    );
    addTearDown(composition.close);
    await _seedSupervisorShift(composition);
    final (panId, galletasId) = await _seedTwoProducts(composition);

    final saleId = await _checkoutSale(
      composition,
      productId: panId,
      quantity: 2,
    );

    await _runExchangeFlow(
      tester,
      composition,
      saleId,
      panId,
      galletasId,
      'Galletas',
    );

    await tester.tap(find.byKey(const Key('product_exchange_submit_button')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('product_exchange_success_snackbar')),
      findsOneWidget,
    );
  });

  testWidgets('SC-091-UI-02 diferencia mayor con pago efectivo', (tester) async {
    final composition = PosComposition.memory(
      dteGateway: FakeDteGateway(mode: FakeDteMode.rechazadaSii),
    );
    addTearDown(composition.close);
    await _seedSupervisorShift(composition);
    final (panId, galletasId) = await _seedTwoProducts(
      composition,
      panPrice: 500,
      otherPrice: 900,
    );

    final saleId = await _checkoutSale(
      composition,
      productId: panId,
      quantity: 1,
      unitPrice: 500,
    );

    await _runExchangeFlow(
      tester,
      composition,
      saleId,
      panId,
      galletasId,
      'Galletas',
    );

    expect(find.byKey(const Key('product_exchange_payment_amount')), findsOneWidget);
    await tester.tap(find.byKey(const Key('product_exchange_submit_button')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('product_exchange_success_snackbar')),
      findsOneWidget,
    );
  });

  test('SC-091-UI-03 cajero sin Cambio mostrador en menú', () {
    final entries = PosMenuPolicy.visibleForTemplateId(
      UserRole.cajero,
      PosTemplateId.atriaPos,
    );
    expect(entries, isNot(contains(PosMenuEntry.productExchange)));
  });

  testWidgets('SC-091-UI-04 venta emitida bloquea confirmación', (tester) async {
    final composition = PosComposition.memory();
    addTearDown(composition.close);
    await _seedSupervisorShift(composition);
    final (panId, _) = await _seedTwoProducts(composition);

    final saleId = await _checkoutSale(
      composition,
      productId: panId,
      quantity: 1,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ProductExchangeScreen(composition: composition),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('product_exchange_sale_id_field')),
      saleId,
    );
    await tester.tap(find.byKey(const Key('product_exchange_load_button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('product_exchange_error')), findsOneWidget);
    expect(find.byKey(const Key('product_exchange_submit_button')), findsNothing);
  });

  testWidgets('SC-091-UI-05 segundo cambio parcial en misma venta', (tester) async {
    final composition = PosComposition.memory(
      dteGateway: FakeDteGateway(mode: FakeDteMode.rechazadaSii),
    );
    addTearDown(composition.close);
    await _seedSupervisorShift(composition);
    final (panId, galletasId) = await _seedTwoProducts(composition);

    final saleId = await _checkoutSale(
      composition,
      productId: panId,
      quantity: 2,
    );

    await _runExchangeFlow(
      tester,
      composition,
      saleId,
      panId,
      galletasId,
      'Galletas',
    );
    await tester.tap(find.byKey(const Key('product_exchange_submit_button')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('product_exchange_load_button')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key('product_exchange_return_$panId')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('product_exchange_return_qty_field')),
      '1',
    );
    await tester.enterText(
      find.byKey(const Key('product_exchange_search_field')),
      'Galletas',
    );
    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('product_exchange_pick_$galletasId')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('product_exchange_new_qty_field')),
      '1',
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('product_exchange_submit_button')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('product_exchange_success_snackbar')),
      findsOneWidget,
    );
  });
}