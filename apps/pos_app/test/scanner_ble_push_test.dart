import 'package:core/api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app/config/store_config.dart';
import 'package:pos_app/di/pos_composition.dart';
import 'package:pos_app/main.dart' as app;
import 'package:pos_app/scanner/scanner_ingress.dart';

/// Separado de `scanner_ble_ui_test` para evitar interferencia de tickers entre casos.
void main() {
  testWidgets('SC-011-BLE-UI push agrega producto único al carro', (tester) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final ingress = StreamScannerIngress();
    final composition = PosComposition.memory(scannerIngress: ingress);
    addTearDown(composition.close);
    addTearDown(ingress.dispose);
    addTearDown(() async => app.disposePosApp());

    await composition.ensureDemoStore();
    await composition.ensureDemoUsers();
    await composition.authService.login(
      kDemoStoreId,
      const LoginRequest(username: 'usr_supervisor', pin: PosComposition.demoPin),
    );
    final created = await composition.productService.createProduct(
      kDemoStoreId,
      const CreateProductRequest(
        name: 'Yogur',
        salePriceClp: 700,
        initialStock: 5,
      ),
    );
    final payload = (created as ApiSuccess<ProductResponse>).data.qrPayload!;
    composition.sessionProvider.clear();

    await app.main(testComposition: composition);
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('login_pin_field')),
      PosComposition.demoPin,
    );
    await tester.tap(find.byKey(const Key('login_button')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('shift_open_button')));
    await tester.pumpAndSettle();

    ingress.push(payload);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('cart_total_label')), findsOneWidget);
expect(find.text('\$700'), findsOneWidget);
  });
}