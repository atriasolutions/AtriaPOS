import 'package:core/api/api.dart';
import 'package:core/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app/config/store_config.dart';
import 'package:pos_app/di/pos_composition.dart';
import 'package:pos_app/screens/sale_screen.dart';

import 'wide_viewport.dart';

Future<void> _openSaleMenu(WidgetTester tester, PosComposition composition) async {
  await tester.pumpWidget(
    MaterialApp(home: SaleScreen(composition: composition)),
  );
  await tester.pumpAndSettle();
  final menu = find.byKey(const Key('operation_menu_button'));
  if (menu.evaluate().isNotEmpty) {
    await tester.tap(menu);
    await tester.pumpAndSettle();
  }
}

void main() {
  testWidgets('SC-076-UI-01 dueño Atria ve ítems clave', (tester) async {
    setWideSaleViewport(tester);
    addTearDown(tester.view.resetPhysicalSize);

    final composition = PosComposition.memory();
    addTearDown(composition.close);
    await composition.ensureDemoStore();
    await composition.ensureDemoUsers();
    await composition.authService.login(
      kDemoStoreId,
      const LoginRequest(username: 'usr_dueno', pin: PosComposition.demoPin),
    );
    await composition.shiftService.openShift(
      kDemoStoreId,
      const OpenShiftRequest(openingCashClp: 0),
    );

    await _openSaleMenu(tester, composition);

    expect(find.byKey(const Key('operation_menu_stock_insights')), findsOneWidget);
    expect(find.byKey(const Key('operation_menu_users')), findsOneWidget);
  });

  testWidgets('SC-076-UI-02 cajero Atria sin usuarios', (tester) async {
    setWideSaleViewport(tester);
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

    await _openSaleMenu(tester, composition);

    expect(find.byKey(const Key('operation_menu_users')), findsNothing);
  });

  testWidgets('SC-076-UI-03 supervisor plantilla mínima', (tester) async {
    setWideSaleViewport(tester);
    addTearDown(tester.view.resetPhysicalSize);

    final composition = PosComposition.memory();
    addTearDown(composition.close);
    await composition.ensureDemoStore(templateId: PosTemplateId.barrioMinTest);
    await composition.ensureDemoUsers();
    await composition.authService.login(
      kDemoStoreId,
      const LoginRequest(username: 'usr_supervisor', pin: PosComposition.demoPin),
    );
    await composition.shiftService.openShift(
      kDemoStoreId,
      const OpenShiftRequest(openingCashClp: 0),
    );

    await _openSaleMenu(tester, composition);

    expect(find.byKey(const Key('operation_menu_users')), findsNothing);
    expect(find.byKey(const Key('operation_menu_stock_insights')), findsNothing);
    expect(find.byKey(const Key('operation_menu_stock_receipt')), findsNothing);
  });

  testWidgets('SC-076-UI-04 checkout sin vendedor plantilla mínima', (tester) async {
    setWideSaleViewport(tester);
    addTearDown(tester.view.resetPhysicalSize);

    final composition = PosComposition.memory();
    addTearDown(composition.close);
    await composition.ensureDemoStore(templateId: PosTemplateId.barrioMinTest);
    expect(
      await composition.resolveActiveTemplateId(),
      PosTemplateId.barrioMinTest,
    );
    final storeRow = await composition.stores.findById(kDemoStoreId);
    expect(storeRow?.posTemplateId, PosTemplateId.barrioMinTest);
    await composition.ensureDemoUsers();
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

    expect(find.byKey(const Key('checkout_seller_dropdown')), findsNothing);
    expect(find.byKey(const Key('checkout_seller_code_field')), findsNothing);
    expect(find.byKey(const Key('confirm_checkout_button')), findsOneWidget);

    final confirm = find.byKey(const Key('confirm_checkout_button'));
    expect(tester.widget<FilledButton>(confirm).onPressed, isNotNull);

    await tester.tap(confirm);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('checkout_validation_snackbar')), findsNothing);
    expect(find.byKey(const Key('checkout_result_dialog')), findsOneWidget);
  });
}