import 'package:core/api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app/config/store_config.dart';
import 'package:pos_app/di/pos_composition.dart';
import 'package:pos_app/main.dart' as app;

void main() {
  testWidgets('SC-080-ASSIST-UI-01 checkout muestra sale_id para evidencia SII',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    final composition = PosComposition.memory();
    addTearDown(composition.close);

    await composition.ensureDemoStore();
    await composition.ensureDemoUsers();
    await composition.authService.login(
      kDemoStoreId,
      const LoginRequest(userId: 'usr_supervisor', pin: PosComposition.demoPin),
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

    final searchField = find.byKey(const Key('product_search_field'));
    await tester.enterText(searchField, 'Pan');
    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();

    final productTile = find.byKey(Key('product_tile_$productId'));
    await tester.tap(productTile);
    await tester.pumpAndSettle();

    final checkout = find.byKey(const Key('checkout_button'));
    await tester.ensureVisible(checkout);
    await tester.tapAt(tester.getRect(checkout).center);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('confirm_checkout_button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('checkout_result_dialog')), findsOneWidget);
    final saleIdLabel = find.byKey(const Key('checkout_sale_id_label'));
    expect(saleIdLabel, findsOneWidget);

    final labelText = tester.widget<Text>(saleIdLabel).data!;
    expect(labelText, startsWith('Venta (sale_id): '));
    final saleId = labelText.replaceFirst('Venta (sale_id): ', '');
    expect(saleId.trim(), isNotEmpty);
  });
}