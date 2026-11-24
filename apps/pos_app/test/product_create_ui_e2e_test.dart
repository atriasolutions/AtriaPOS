import 'package:core/api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app/config/store_config.dart';
import 'package:pos_app/di/pos_composition.dart';
import 'package:pos_app/screens/product_create_screen.dart';
import 'package:pos_app/screens/sale_screen.dart';

void main() {
  testWidgets('SC-010-UI-01 crear producto y aparece en búsqueda', (tester) async {
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
      MaterialApp(
        home: ProductCreateScreen(composition: composition),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('product_create_name_field')),
      'Yogurt',
    );
    await tester.enterText(
      find.byKey(const Key('product_create_price_field')),
      '1200',
    );
    await tester.enterText(
      find.byKey(const Key('product_create_stock_field')),
      '5',
    );
    await tester.tap(find.byKey(const Key('product_create_submit_button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('product_create_success_snackbar')), findsOneWidget);

    await tester.pumpWidget(
      MaterialApp(
        home: SaleScreen(composition: composition),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('product_search_field')),
      'Yog',
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(find.text('Yogurt'), findsWidgets);
    expect(find.textContaining('\$1200'), findsWidgets);
  });

  testWidgets('SC-010-UI-02 cajero sin menú operación', (tester) async {
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

    expect(find.byKey(const Key('operation_menu_button')), findsNothing);
    expect(find.byKey(const Key('operation_menu_product')), findsNothing);
  });

  testWidgets('SC-010-UI-03 precio cero rechazado en UI', (tester) async {
    final composition = PosComposition.memory();
    addTearDown(composition.close);
    await composition.ensureDemoStore();
    await composition.ensureDemoUsers();
    await composition.authService.login(
      kDemoStoreId,
      const LoginRequest(username: 'usr_supervisor', pin: PosComposition.demoPin),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ProductCreateScreen(composition: composition),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('product_create_name_field')),
      'Test',
    );
    await tester.enterText(
      find.byKey(const Key('product_create_price_field')),
      '0',
    );
    await tester.tap(find.byKey(const Key('product_create_submit_button')));
    await tester.pumpAndSettle();

    expect(
      find.text('Ingrese un precio de venta mayor a cero.'),
      findsOneWidget,
    );
  });
}