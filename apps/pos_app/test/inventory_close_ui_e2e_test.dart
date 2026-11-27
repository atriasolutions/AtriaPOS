import 'package:core/api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app/config/store_config.dart';
import 'package:pos_app/di/pos_composition.dart';
import 'package:pos_app/screens/inventory_close_screen.dart';

Future<String> _seedShiftSale(PosComposition composition) async {
  await composition.ensureDemoStore();
  await composition.ensureDemoUsers();
  await composition.ensureDemoSeller();
  await composition.authService.login(
    kDemoStoreId,
    const LoginRequest(username: 'usr_supervisor', pin: PosComposition.demoPin),
  );
  await composition.shiftService.openShift(
    kDemoStoreId,
    const OpenShiftRequest(openingCashClp: 0),
  );
  final product = await composition.productService.createProduct(
    kDemoStoreId,
    const CreateProductRequest(
      name: 'Yogurt',
      salePriceClp: 700,
      initialStock: 10,
    ),
  );
  final productId = (product as ApiSuccess<ProductResponse>).data.id;
  final cart = await composition.saleService.createCart(kDemoStoreId);
  final cartId = (cart as ApiSuccess<CreateCartResponse>).data.cartId;
  await composition.saleService.addLine(
    kDemoStoreId,
    cartId,
    AddCartLineRequest(productId: productId, quantity: 1),
  );
  await composition.saleService.checkout(
    kDemoStoreId,
    cartId,
  CheckoutRequest(
      sellerCode: 'V01',
      payments: [CheckoutPaymentDto(method: 'EFECTIVO', amountClp: 700)],
      changeClp: 0,
    ),
  );
  return productId;
}

void main() {
  testWidgets('SC-088-UI-01 preview con vendidos en turno', (tester) async {
    final composition = PosComposition.memory();
    addTearDown(composition.close);
    final productId = await _seedShiftSale(composition);

    await tester.pumpWidget(
      MaterialApp(home: InventoryCloseScreen(composition: composition)),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('inventory_close_list')), findsOneWidget);
    expect(
      find.byKey(Key('inventory_close_system_$productId')),
      findsOneWidget,
    );
    expect(
      find.byKey(Key('inventory_close_sold_$productId')),
      findsOneWidget,
    );
    expect(find.textContaining('Vendidos en turno: 1'), findsOneWidget);
  });

  testWidgets('SC-154-UI-01 inicia sin contar', (tester) async {
    final composition = PosComposition.memory();
    addTearDown(composition.close);
    final productId = await _seedShiftSale(composition);

    await tester.pumpWidget(
      MaterialApp(home: InventoryCloseScreen(composition: composition)),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(Key('inventory_line_status_$productId')),
      findsOneWidget,
    );
    expect(find.text('Sin contar'), findsOneWidget);
    final button = tester.widget<FilledButton>(
      find.byKey(const Key('inventory_close_submit_button')),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('SC-154-UI-02 diferencia en rojo', (tester) async {
    final composition = PosComposition.memory();
    addTearDown(composition.close);
    final productId = await _seedShiftSale(composition);

    await tester.pumpWidget(
      MaterialApp(home: InventoryCloseScreen(composition: composition)),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(Key('inventory_close_count_$productId')),
      '8',
    );
    await tester.pumpAndSettle();

    expect(find.text('Diferencias'), findsOneWidget);
    expect(find.byKey(Key('inventory_line_delta_$productId')), findsOneWidget);
  });

  testWidgets('SC-154-UI-03 habilita cierre al completar', (tester) async {
    final composition = PosComposition.memory();
    addTearDown(composition.close);
    final productId = await _seedShiftSale(composition);

    await tester.pumpWidget(
      MaterialApp(home: InventoryCloseScreen(composition: composition)),
    );
    await tester.pumpAndSettle();

    expect(
      tester.widget<FilledButton>(
        find.byKey(const Key('inventory_close_submit_button')),
      ).onPressed,
      isNull,
    );
    await tester.enterText(
      find.byKey(Key('inventory_close_count_$productId')),
      '9',
    );
    await tester.pumpAndSettle();
    expect(
      tester.widget<FilledButton>(
        find.byKey(const Key('inventory_close_submit_button')),
      ).onPressed,
      isNotNull,
    );
  });

  testWidgets('SC-088-UI-02 cierre con corrección', (tester) async {
    final composition = PosComposition.memory();
    addTearDown(composition.close);
    final productId = await _seedShiftSale(composition);

    await tester.pumpWidget(
      MaterialApp(home: InventoryCloseScreen(composition: composition)),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(Key('inventory_close_count_$productId')),
      '8',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('inventory_close_submit_button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('inventory_close_success')), findsOneWidget);
    expect(find.textContaining('ajuste'), findsOneWidget);
  });

  testWidgets('SC-088-UI-03 sin turno abierto', (tester) async {
    final composition = PosComposition.memory();
    addTearDown(composition.close);
    await composition.ensureDemoStore();
    await composition.ensureDemoUsers();
    await composition.authService.login(
      kDemoStoreId,
      const LoginRequest(username: 'usr_supervisor', pin: PosComposition.demoPin),
    );

    await tester.pumpWidget(
      MaterialApp(home: InventoryCloseScreen(composition: composition)),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('inventory_close_no_shift')), findsOneWidget);
    expect(find.byKey(const Key('inventory_close_list')), findsNothing);
  });
}