import 'package:core/api/api.dart';
import 'package:core/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app/config/store_config.dart';
import 'package:pos_app/di/pos_composition.dart';
import 'package:pos_app/screens/store_config_screen.dart';

import 'wide_viewport.dart';

void main() {
  testWidgets('SC-165-UI-01 dueño ve configuración tienda', (tester) async {
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

    await tester.pumpWidget(
      MaterialApp(home: StoreConfigScreen(composition: composition)),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('store_config_section_ventas')), findsOneWidget);
    expect(find.byKey(const Key('store_config_section_inventario')), findsOneWidget);
    expect(find.byKey(const Key('store_config_section_fiscal')), findsOneWidget);
    expect(find.byKey(const Key('store_config_seller_code')), findsOneWidget);
    expect(find.byKey(const Key('store_config_transbank')), findsOneWidget);
    expect(find.text('Pago integrado con tarjeta'), findsOneWidget);
  });

  testWidgets('SC-165-UI-02 activar vendedor refleja en menú venta', (tester) async {
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

    final patch = await composition.storeService.patchStoreOperationalConfig(
      kDemoStoreId,
      const PatchStoreOperationalConfigRequest(sellerCodeRequired: true),
    );
    expect(patch, isA<ApiSuccess<StoreOperationalConfigResponse>>());

    final store = await composition.resolveActiveStore();
    expect(store, isNotNull);
    final tpl = composition.effectiveTemplateForStore(store!);
    expect(tpl.hasFeature(PosFeature.sellerCodeCheckout), isTrue);
  });
}