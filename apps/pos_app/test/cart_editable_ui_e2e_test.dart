import 'package:core/api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app/config/store_config.dart';
import 'package:pos_app/di/pos_composition.dart';
import 'package:pos_app/screens/sale_screen.dart';

Future<String> _preparePanProduct(PosComposition composition) async {
  await composition.ensureDemoStore();
  await composition.ensureDemoUsers();
  await composition.authService.login(
    kDemoStoreId,
    const LoginRequest(username: 'usr_supervisor', pin: PosComposition.demoPin),
  );
  final created = await composition.productService.createProduct(
    kDemoStoreId,
    const CreateProductRequest(
      name: 'Pan',
      salePriceClp: 500,
      initialStock: 10,
    ),
  );
  switch (created) {
    case ApiSuccess<ProductResponse>(data: final data):
      return data.id;
    case ApiFailure<ProductResponse>(error: final e):
      throw TestFailure('No se pudo crear producto: ${e.message}');
  }
}

Future<Finder> _openSaleScreen(
  WidgetTester tester,
  PosComposition composition, {
  required String username,
  required String productId,
}) async {
  await composition.authService.login(
    kDemoStoreId,
    LoginRequest(username: username, pin: PosComposition.demoPin),
  );
  await composition.shiftService.openShift(
    kDemoStoreId,
    const OpenShiftRequest(openingCashClp: 0),
  );

  await tester.pumpWidget(
    MaterialApp(home: SaleScreen(composition: composition)),
  );
  await tester.pumpAndSettle();

  await tester.enterText(find.byKey(const Key('product_search_field')), 'Pan');
  await tester.tap(find.byKey(const Key('product_search_submit')));
  await tester.pumpAndSettle();

  return find.byKey(Key('product_tile_$productId'));
}

Finder get _cartQtyMinus => find.byWidgetPredicate(
      (w) =>
          w.key is ValueKey<String> &&
          (w.key! as ValueKey<String>).value.startsWith('cart_line_qty_minus_'),
    );

Finder get _cartQtyPlus => find.byWidgetPredicate(
      (w) =>
          w.key is ValueKey<String> &&
          (w.key! as ValueKey<String>).value.startsWith('cart_line_qty_plus_'),
    );

Finder get _cartLineRemove => find.byWidgetPredicate(
      (w) =>
          w.key is ValueKey<String> &&
          (w.key! as ValueKey<String>).value.startsWith('cart_line_remove_'),
    );

void main() {
  testWidgets('SC-082-UI-01 cajero baja cantidad y total actualiza', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final composition = PosComposition.memory();
    addTearDown(composition.close);
    final productId = await _preparePanProduct(composition);
    final productTile = await _openSaleScreen(
      tester,
      composition,
      username: 'usr_cajero',
      productId: productId,
    );

    await tester.tap(productTile);
    await tester.pumpAndSettle();
    await tester.tap(_cartQtyPlus);
    await tester.pumpAndSettle();
    expect(
      find.byWidgetPredicate(
        (w) => w.key == const Key('cart_total_label') && w is Text && (w).data == '\$1000',
      ),
      findsOneWidget,
    );

    await tester.tap(_cartQtyMinus);
    await tester.pumpAndSettle();
    expect(
      find.byWidgetPredicate(
        (w) => w.key == const Key('cart_total_label') && w is Text && (w).data == '\$500',
      ),
      findsOneWidget,
    );
  });

  testWidgets('SC-082-UI-02 cajero elimina línea deja carro vacío', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final composition = PosComposition.memory();
    addTearDown(composition.close);
    final productId = await _preparePanProduct(composition);
    final productTile = await _openSaleScreen(
      tester,
      composition,
      username: 'usr_cajero',
      productId: productId,
    );

    await tester.tap(productTile);
    await tester.pumpAndSettle();
    expect(
      find.byWidgetPredicate(
        (w) => w.key == const Key('cart_total_label') && w is Text && (w).data == '\$500',
      ),
      findsOneWidget,
    );

    await tester.tap(_cartLineRemove);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('sale_cart_empty_state')), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (w) => w.key == const Key('cart_total_label') && w is Text && (w).data == '\$0',
      ),
      findsOneWidget,
    );
  });

  testWidgets('SC-082-UI-03 supervisor edita cantidad', (tester) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final composition = PosComposition.memory();
    addTearDown(composition.close);
    final productId = await _preparePanProduct(composition);
    final productTile = await _openSaleScreen(
      tester,
      composition,
      username: 'usr_supervisor',
      productId: productId,
    );

    await tester.tap(productTile);
    await tester.pumpAndSettle();
    await tester.tap(_cartQtyPlus);
    await tester.pumpAndSettle();
    await tester.tap(_cartQtyMinus);
    await tester.pumpAndSettle();
    expect(
      find.byWidgetPredicate(
        (w) => w.key == const Key('cart_total_label') && w is Text && (w).data == '\$500',
      ),
      findsOneWidget,
    );
  });
}