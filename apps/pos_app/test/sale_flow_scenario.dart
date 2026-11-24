import 'package:core/api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app/config/store_config.dart';
import 'package:pos_app/di/pos_composition.dart';
import 'package:pos_app/main.dart' as app;

import 'checkout_test_helpers.dart';

/// SC-060-01 — compartido entre `test/` y `integration_test/`.
Future<void> runSaleFlowScenario(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1280, 900);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  final composition = PosComposition.memory();
  addTearDown(composition.close);

  await composition.ensureDemoStore();
  await composition.ensureDemoUsers();
  await composition.ensureDemoSeller();
  await composition.authService.login(
    kDemoStoreId,
    const LoginRequest(username: 'usr_supervisor', pin: PosComposition.demoPin),
  );
  final created = await composition.productService.createProduct(
    kDemoStoreId,
    const CreateProductRequest(
      name: 'Pan',
      salePriceClp: 500,
      initialStock: 10,
    ),
  );
  final productId = (created as ApiSuccess<ProductResponse>).data.id;
  composition.sessionProvider.clear();

  await app.main(testComposition: composition);
  await tester.pumpAndSettle();

  await tester.enterText(
    find.byKey(const Key('login_pin_field')),
    PosComposition.demoPin,
  );
  await tester.tap(find.byKey(const Key('login_button')));
  await tester.pumpAndSettle();

  expect(find.byKey(const Key('shift_open_button')), findsOneWidget);
  await tester.tap(find.byKey(const Key('shift_open_button')));
  await tester.pumpAndSettle();

  final searchField = find.byKey(const Key('product_search_field'));
  expect(searchField, findsOneWidget);
  await tester.enterText(searchField, 'Pan');
  await tester.tap(find.byKey(const Key('product_search_submit')));
  await tester.pumpAndSettle();

  final productTile = find.byKey(Key('product_tile_$productId'));
  await tester.tap(productTile);
  await tester.pumpAndSettle();
  await tester.tap(productTile);
  await tester.pumpAndSettle();

  expect(find.byKey(const Key('cart_total_label')), findsOneWidget);
  expect(find.textContaining('\$1000'), findsOneWidget);

  await enterCheckoutSellerCode(tester);
  await tester.tap(find.byKey(const Key('confirm_checkout_button')));
  await tester.pumpAndSettle();

  expect(find.textContaining('EMITIDA'), findsOneWidget);
  await tester.tap(find.text('Listo'));
  await tester.pumpAndSettle();

  final stock = await composition.inventoryService.getProductStock(
    kDemoStoreId,
    (await composition.productService.searchProducts(kDemoStoreId, 'Pan')
            as ApiSuccess<SearchProductsResponse>)
        .data
        .items
        .first
        .id,
  );
  expect((stock as ApiSuccess<StockResponse>).data.stock, 8);
}