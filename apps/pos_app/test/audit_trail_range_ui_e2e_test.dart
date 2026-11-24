import 'package:core/api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app/config/store_config.dart';
import 'package:pos_app/di/pos_composition.dart';
import 'package:pos_app/screens/audit_trail_screen.dart';
import 'package:pos_app/screens/sale_screen.dart';

Future<void> _seedSaleAndMerma(PosComposition composition) async {
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
      name: 'Pan',
      salePriceClp: 500,
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
    const CheckoutRequest(
      sellerCode: 'V01',
      payments: [CheckoutPaymentDto(method: 'EFECTIVO', amountClp: 500)],
      changeClp: 0,
    ),
  );
  await composition.inventoryService.adjustStock(
    kDemoStoreId,
    productId,
    const AdjustStockRequest(delta: -1, reason: 'MERMA'),
  );
}

void main() {
  testWidgets('SC-086-UI-01 filtro solo VENTAS', (tester) async {
    final composition = PosComposition.memory();
    addTearDown(composition.close);
    await _seedSaleAndMerma(composition);

    await tester.pumpWidget(
      MaterialApp(home: AuditTrailScreen(composition: composition)),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('AJUSTE_STOCK'), findsWidgets);

    await tester.tap(find.byKey(const Key('audit_trail_cat_inventario')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('audit_trail_cat_usuarios')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('audit_trail_apply_button')));
    await tester.pumpAndSettle();

    expect(find.textContaining('CONFIRMA_VENTA'), findsWidgets);
    expect(find.textContaining('AJUSTE_STOCK'), findsNothing);
  });

  testWidgets('SC-086-UI-02 cabecera de rango', (tester) async {
    final composition = PosComposition.memory();
    addTearDown(composition.close);
    await _seedSaleAndMerma(composition);

    await tester.pumpWidget(
      MaterialApp(home: AuditTrailScreen(composition: composition)),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('audit_trail_range_label')), findsOneWidget);
    expect(find.byKey(const Key('audit_trail_list')), findsOneWidget);
  });

  testWidgets('SC-086-UI-03 rango inválido', (tester) async {
    final composition = PosComposition.memory();
    addTearDown(composition.close);
    await composition.ensureDemoStore();
    await composition.ensureDemoUsers();
    await composition.authService.login(
      kDemoStoreId,
      const LoginRequest(username: 'usr_supervisor', pin: PosComposition.demoPin),
    );

    await tester.pumpWidget(
      MaterialApp(home: AuditTrailScreen(composition: composition)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('audit_trail_from_button')));
    await tester.pumpAndSettle();

    final tomorrow = DateTime.now().add(const Duration(days: 1));
    await tester.tap(find.text('${tomorrow.day}'));
    await tester.pumpAndSettle();

    final accept = find.widgetWithText(TextButton, 'Aceptar');
    if (accept.evaluate().isNotEmpty) {
      await tester.tap(accept);
    } else {
      await tester.tap(find.widgetWithText(TextButton, 'OK'));
    }
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('audit_trail_apply_button')));
    await tester.pumpAndSettle();

    expect(
      find.text('La fecha hasta no puede ser anterior a desde.'),
      findsOneWidget,
    );
  });

  testWidgets('SC-086-UI-02 menú operación conserva auditoría', (tester) async {
    final composition = PosComposition.memory();
    addTearDown(composition.close);
    await _seedSaleAndMerma(composition);

    await tester.pumpWidget(
      MaterialApp(home: SaleScreen(composition: composition)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('operation_menu_button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('operation_menu_audit')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('audit_trail_apply_button')), findsOneWidget);
    expect(find.byKey(const Key('audit_trail_list')), findsOneWidget);
  });
}