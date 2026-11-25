import 'package:core/api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app/config/store_config.dart';
import 'package:pos_app/di/pos_composition.dart';
import 'package:pos_app/screens/sale_screen.dart';

Future<void> _prepareCart(WidgetTester tester, PosComposition composition) async {
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
}

void main() {
  testWidgets('SC-093-UI-01 selector factura muestra campos receptor', (tester) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final composition = PosComposition.memory();
    addTearDown(composition.close);

    await _prepareCart(tester, composition);

    expect(find.byKey(const Key('checkout_invoice_rut')), findsNothing);
    await tester.tap(find.text('Factura'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('checkout_invoice_rut')), findsOneWidget);
    expect(find.byKey(const Key('checkout_invoice_business_name')), findsOneWidget);
  });

  testWidgets('SC-093-UI-02 checkout factura válida', (tester) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final composition = PosComposition.memory();
    addTearDown(composition.close);

    await _prepareCart(tester, composition);

    await tester.tap(find.text('Factura'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('checkout_invoice_rut')),
      '123456785',
    );
    await tester.enterText(
      find.byKey(const Key('checkout_invoice_business_name')),
      'Cliente SpA',
    );
    await tester.pumpAndSettle();

    final sellerField = find.byKey(const Key('checkout_seller_code_field'));
    if (sellerField.evaluate().isNotEmpty) {
      await tester.enterText(sellerField, 'V01');
    } else {
      await tester.tap(find.byKey(const Key('checkout_seller_dropdown')));
      await tester.pumpAndSettle();
      await tester.tap(find.textContaining('V01').first);
      await tester.pumpAndSettle();
    }

    await tester.tap(find.byKey(const Key('confirm_checkout_button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('checkout_result_dialog')), findsOneWidget);
  });

  testWidgets('SC-093-UI-03 RUT inválido muestra validación', (tester) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final composition = PosComposition.memory();
    addTearDown(composition.close);

    await _prepareCart(tester, composition);

    await tester.tap(find.text('Factura'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('checkout_invoice_rut')),
      '123456780',
    );
    await tester.enterText(
      find.byKey(const Key('checkout_invoice_business_name')),
      'Cliente SpA',
    );
    await tester.pumpAndSettle();

    final sellerField = find.byKey(const Key('checkout_seller_code_field'));
    if (sellerField.evaluate().isNotEmpty) {
      await tester.enterText(sellerField, 'V01');
    } else {
      await tester.tap(find.byKey(const Key('checkout_seller_dropdown')));
      await tester.pumpAndSettle();
      await tester.tap(find.textContaining('V01').first);
      await tester.pumpAndSettle();
    }

    await tester.tap(find.byKey(const Key('confirm_checkout_button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('checkout_validation_snackbar')), findsOneWidget);
  });
}