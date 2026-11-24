import 'package:core/api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app/config/store_config.dart';
import 'package:pos_app/di/pos_composition.dart';
import 'package:pos_app/screens/sale_screen.dart';

import 'checkout_test_helpers.dart';

void main() {
  testWidgets('SC-075-UI-01 empty state', (tester) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final composition = PosComposition.memory();
    addTearDown(composition.close);
    await composition.ensureDemoStore();
    await composition.ensureDemoUsers();
    await composition.authService.login(
      kDemoStoreId,
      const LoginRequest(username: 'usr_cajero', pin: PosComposition.demoPin),
    );
    await composition.shiftService.openShift(
      kDemoStoreId,
      const OpenShiftRequest(openingCashClp: 0),
    );

    await tester.pumpWidget(
      MaterialApp(home: SaleScreen(composition: composition)),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('sale_cart_empty_state')), findsOneWidget);
    expect(find.textContaining('El carrito está vacío'), findsOneWidget);
  });

  testWidgets('SC-075-UI-02 cobro en panel derecho', (tester) async {
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
    await composition.shiftService.openShift(
      kDemoStoreId,
      const OpenShiftRequest(openingCashClp: 0),
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

    await tester.pumpWidget(
      MaterialApp(home: SaleScreen(composition: composition)),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('product_search_field')), 'Pan');
    await tester.tap(find.byKey(const Key('product_search_submit')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('product_tile_$productId')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('confirm_checkout_button')), findsOneWidget);
    await enterCheckoutSellerCode(tester);
    await tester.tap(find.byKey(const Key('confirm_checkout_button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('checkout_result_dialog')), findsOneWidget);
  });

  testWidgets('SC-075-UI-03 menú operación en top bar', (tester) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final composition = PosComposition.memory();
    addTearDown(composition.close);
    await composition.ensureDemoStore();
    await composition.ensureDemoUsers();
    await composition.authService.login(
      kDemoStoreId,
      const LoginRequest(username: 'usr_supervisor', pin: PosComposition.demoPin),
    );
    await composition.shiftService.openShift(
      kDemoStoreId,
      const OpenShiftRequest(openingCashClp: 0),
    );

    await tester.pumpWidget(
      MaterialApp(home: SaleScreen(composition: composition)),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('operation_menu_button')), findsOneWidget);
  });
}