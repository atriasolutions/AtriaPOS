import 'package:core/api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app/app_shell.dart';
import 'package:pos_app/config/store_config.dart';
import 'package:pos_app/di/pos_composition.dart';
import 'package:pos_app/screens/sale_screen.dart';

void main() {
  testWidgets('SC-070-UI-01 auditoría del día en menú operación', (tester) async {
    final composition = PosComposition.memory();
    addTearDown(composition.close);
    await composition.ensureDemoStore();
    await composition.ensureDemoUsers();
    await composition.authService.login(
      kDemoStoreId,
      const LoginRequest(userId: 'usr_supervisor', pin: PosComposition.demoPin),
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
        payments: [CheckoutPaymentDto(method: 'EFECTIVO', amountClp: 500)],
        changeClp: 0,
      ),
    );

    await composition.inventoryService.adjustStock(
      kDemoStoreId,
      productId,
      const AdjustStockRequest(
        delta: -1,
        reason: 'MERMA',
      ),
    );

    await tester.pumpWidget(
      MaterialApp(home: SaleScreen(composition: composition)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('operation_menu_button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('operation_menu_audit')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('audit_trail_list')), findsOneWidget);
    expect(find.textContaining('CONFIRMA_VENTA'), findsWidgets);
    expect(find.textContaining('usr_supervisor'), findsWidgets);
    expect(find.textContaining('AJUSTE_STOCK'), findsWidgets);
  });

  testWidgets('SC-070-UI-02 cajero sin ítem auditoría', (tester) async {
    final composition = PosComposition.memory();
    addTearDown(composition.close);
    await composition.ensureDemoStore();
    await composition.ensureDemoUsers();
    await composition.authService.login(
      kDemoStoreId,
      const LoginRequest(userId: 'usr_cajero', pin: PosComposition.demoPin),
    );
    await composition.shiftService.openShift(
      kDemoStoreId,
      const OpenShiftRequest(openingCashClp: 1000),
    );

    await tester.pumpWidget(
      MaterialApp(home: AppShell(composition: composition)),
    );
    await tester.pumpAndSettle();

    final menuButton = find.byKey(const Key('operation_menu_button'));
    if (menuButton.evaluate().isNotEmpty) {
      await tester.tap(menuButton);
      await tester.pumpAndSettle();
    }
    expect(find.byKey(const Key('operation_menu_audit')), findsNothing);
  });
}