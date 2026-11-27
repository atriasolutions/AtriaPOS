import 'package:core/api/api.dart';
import 'package:core/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app/config/store_config.dart';
import 'package:pos_app/di/pos_composition.dart';
import 'package:pos_app/screens/sale_screen.dart';

import 'options_navigation_helpers.dart';
import 'wide_viewport.dart';

void main() {
  testWidgets('SC-168-UI-01 dueño ve secciones agrupadas', (tester) async {
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

    await tester.pumpWidget(
      MaterialApp(home: SaleScreen(composition: composition)),
    );
    await tester.pumpAndSettle();
    await openSaleOptionsScreen(tester);

    expect(find.byKey(const Key('options_section_ventas')), findsOneWidget);
    expect(find.byKey(const Key('options_section_fiscal')), findsOneWidget);
    expect(find.byKey(const Key('options_section_inventario')), findsOneWidget);
    expect(
      find.byKey(const Key('options_section_administracion')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('operation_menu_users')), findsOneWidget);
  });

  testWidgets('SC-168-UI-02 plantilla mínima sin inventario', (tester) async {
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

    await tester.pumpWidget(
      MaterialApp(home: SaleScreen(composition: composition)),
    );
    await tester.pumpAndSettle();
    await openSaleOptionsScreen(tester);

    expect(find.byKey(const Key('operation_menu_stock_receipt')), findsNothing);
    expect(find.byKey(const Key('options_section_ventas')), findsOneWidget);
  });
}