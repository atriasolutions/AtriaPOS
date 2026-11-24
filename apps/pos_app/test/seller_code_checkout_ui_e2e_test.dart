import 'package:core/api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app/config/store_config.dart';
import 'package:pos_app/di/pos_composition.dart';
import 'package:pos_app/screens/sale_screen.dart';

import 'checkout_test_helpers.dart';

Future<String> _openCheckoutDialog(
  WidgetTester tester,
  PosComposition composition,
) async {
  await composition.ensureDemoStore();
  await composition.ensureDemoUsers();
  await composition.ensureDemoSeller();
  await composition.authService.login(
    kDemoStoreId,
    const LoginRequest(username: 'usr_dueno', pin: PosComposition.demoPin),
  );
  await composition.collaboratorService.create(
    kDemoStoreId,
    const CreateCollaboratorRequest(
      sellerCode: 'V02',
      firstName: 'Segundo',
      lastName: 'Colab',
    ),
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

  await tester.enterText(find.byKey(const Key('product_search_field')), 'Pan');
  await tester.tap(find.byKey(const Key('product_search_submit')));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(Key('product_tile_$productId')));
  await tester.pumpAndSettle();

  return productId;
}

void main() {
  testWidgets('SC-084-UI-01 elige vendedor y confirma venta', (tester) async {
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
      const LoginRequest(username: 'usr_cajero', pin: PosComposition.demoPin),
    );
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

    await tester.enterText(find.byKey(const Key('product_search_field')), 'Pan');
    await tester.tap(find.byKey(const Key('product_search_submit')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('product_tile_$productId')));
    await tester.pumpAndSettle();

    await enterCheckoutSellerCode(tester, sellerCode: 'v01');
    await tester.tap(find.byKey(const Key('confirm_checkout_button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('checkout_result_dialog')), findsOneWidget);
  });

  testWidgets('SC-084-UI-02 sin vendedor confirmar deshabilitado', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final composition = PosComposition.memory();
    addTearDown(composition.close);
    await _openCheckoutDialog(tester, composition);

    final button = tester.widget<FilledButton>(
      find.byKey(const Key('confirm_checkout_button')),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('SC-084-UI-03 código inválido muestra validación', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final composition = PosComposition.memory();
    addTearDown(composition.close);
    await _openCheckoutDialog(tester, composition);

    await enterCheckoutSellerCode(tester, sellerCode: 'V99');
    final button = tester.widget<FilledButton>(
      find.byKey(const Key('confirm_checkout_button')),
    );
    expect(button.onPressed, isNotNull);
    await tester.tap(find.byKey(const Key('confirm_checkout_button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('checkout_validation_snackbar')), findsOneWidget);
    expect(find.byKey(const Key('checkout_result_dialog')), findsNothing);
    expect(find.byKey(const Key('confirm_checkout_button')), findsOneWidget);
  });
}