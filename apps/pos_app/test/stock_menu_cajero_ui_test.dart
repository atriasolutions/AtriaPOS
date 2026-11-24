import 'package:core/api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app/config/store_config.dart';
import 'package:pos_app/di/pos_composition.dart';
import 'package:pos_app/screens/sale_screen.dart';

void main() {
  testWidgets('SC-085-UI-03 y SC-087-UI-03 cajero sin menú stock', (tester) async {
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
      MaterialApp(
        home: SaleScreen(composition: composition),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('operation_menu_button')), findsNothing);
    expect(find.byKey(const Key('operation_menu_stock_receipt')), findsNothing);
    expect(find.byKey(const Key('operation_menu_stock_insights')), findsNothing);
  });
}