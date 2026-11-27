import 'package:core/api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app/config/store_config.dart';
import 'package:pos_app/di/pos_composition.dart';
import 'package:pos_app/screens/stock_receipt_screen.dart';
import 'package:pos_app/theme/atria_touch_targets.dart';

void main() {
  testWidgets('SC-085-UI-01 ingreso desde UI', (tester) async {
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
        name: 'Arroz',
        salePriceClp: 900,
        initialStock: 5,
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: StockReceiptScreen(composition: composition),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('stock_receipt_search_field')),
      'Arr',
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(ListTile).first);
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('stock_receipt_quantity_field')),
      '10',
    );
    await tester.enterText(
      find.byKey(const Key('stock_receipt_guide_field')),
      'GD-1',
    );
    await tester.enterText(
      find.byKey(const Key('stock_receipt_lot_ref_field')),
      'L-01',
    );
    await tester.tap(find.byKey(const Key('stock_receipt_submit_button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('stock_receipt_success_snackbar')), findsOneWidget);
    expect(find.textContaining('15 u.'), findsOneWidget);
    expect(
      find.byKey(const Key('stock_receipt_selected_label')),
      findsOneWidget,
    );
    expect(find.textContaining('stock 15'), findsOneWidget);
  });

  testWidgets('SC-085-UI-02 validación formulario', (tester) async {
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
        home: StockReceiptScreen(composition: composition),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('stock_receipt_submit_button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('stock_receipt_success_snackbar')), findsNothing);
    expect(find.text('Seleccione un producto.'), findsOneWidget);
  });

  testWidgets('SC-158-UI-01 CTA ingreso tactil', (tester) async {
    final composition = PosComposition.memory();
    addTearDown(composition.close);
    await composition.ensureDemoStore();
    await composition.ensureDemoUsers();
    await composition.authService.login(
      kDemoStoreId,
      const LoginRequest(username: 'usr_supervisor', pin: PosComposition.demoPin),
    );

    await tester.pumpWidget(
      MaterialApp(home: StockReceiptScreen(composition: composition)),
    );
    await tester.pumpAndSettle();

    final size = tester.getSize(
      find.byKey(const Key('stock_receipt_submit_button')),
    );
    expect(size.height, greaterThanOrEqualTo(kMinTouchHeight - 1));
  });
}