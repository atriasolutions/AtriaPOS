import 'package:core/api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app/config/store_config.dart';
import 'package:pos_app/di/pos_composition.dart';
import 'package:pos_app/screens/stock_adjust_screen.dart';

void main() {
  testWidgets('SC-021-UI-01 merma desde UI', (tester) async {
    final composition = PosComposition.memory();
    addTearDown(composition.close);
    await composition.ensureDemoStore();
    await composition.ensureDemoUsers();
    await composition.authService.login(
      kDemoStoreId,
      const LoginRequest(username: 'usr_supervisor', pin: PosComposition.demoPin),
    );
    await composition.productService.createProduct(
      kDemoStoreId,
      const CreateProductRequest(
        name: 'Leche',
        salePriceClp: 1200,
        initialStock: 10,
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: StockAdjustScreen(composition: composition),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('stock_adjust_search_field')),
      'Lec',
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(ListTile).first);
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('stock_adjust_delta_field')),
      '-1',
    );
    await tester.tap(find.byKey(const Key('stock_adjust_submit_button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('stock_adjust_success_snackbar')), findsOneWidget);
    expect(find.textContaining('Stock actualizado: 9'), findsOneWidget);
  });
}