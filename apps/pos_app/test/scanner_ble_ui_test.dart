import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app/config/store_config.dart';
import 'package:pos_app/di/pos_composition.dart';
import 'package:pos_app/main.dart' as app;
import 'package:pos_app/scanner/ble_central_scanner_ingress.dart';
void main() {
  testWidgets('SC-011-BLE-UI-01 botón conectar muestra código', (tester) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final ingress = BleCentralScannerIngress(enableRadio: false);
  final composition = PosComposition.memory(scannerIngress: ingress);
    addTearDown(composition.close);
    addTearDown(() async {
      await ingress.stop();
      ingress.dispose();
      await app.disposePosApp();
    });

    await composition.ensureDemoStore();
    await composition.ensureDemoUsers();
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

    await tester.tap(find.byKey(const Key('scanner_connect_button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('scanner_pairing_code')), findsOneWidget);
    await tester.tap(find.text('Cerrar'));
    await tester.pumpAndSettle();
  });
}