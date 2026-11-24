import 'package:core/api/api.dart';
import 'package:core/application/application.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app/config/store_config.dart';
import 'package:pos_app/di/pos_composition.dart';
import 'package:pos_app/app_shell.dart';
import 'package:pos_app/screens/shift_sales_screen.dart';

void main() {
  testWidgets('SC-032-UI-01 anula venta desde UI', (tester) async {
    final composition = PosComposition.memory(
      dteGateway: FakeDteGateway(mode: FakeDteMode.rechazadaSii),
    );
    addTearDown(composition.close);
    await composition.ensureDemoStore();
    await composition.ensureDemoUsers();
    await composition.ensureDemoSeller();
    await composition.authService.login(
      kDemoStoreId,
      const LoginRequest(username: 'usr_supervisor', pin: PosComposition.demoPin),
    );
    await composition.shiftService.openShift(
      kDemoStoreId,
      const OpenShiftRequest(openingCashClp: 5000),
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
      AddCartLineRequest(productId: productId, quantity: 2),
    );
    final checkout = await composition.saleService.checkout(
      kDemoStoreId,
      cartId,
      const CheckoutRequest(
        sellerCode: 'V01',
        payments: [CheckoutPaymentDto(method: 'EFECTIVO', amountClp: 1000)],
        changeClp: 0,
      ),
    );
    final saleId = (checkout as ApiSuccess<CheckoutResponse>).data.saleId;

    await tester.pumpWidget(
      MaterialApp(
        home: ShiftSalesScreen(composition: composition),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(Key('shift_sale_tile_$saleId')), findsOneWidget);
    expect(find.byKey(Key('void_sale_button_$saleId')), findsOneWidget);
    await tester.tap(find.byKey(Key('void_sale_button_$saleId')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('void_sale_confirm_button')));
    await tester.pumpAndSettle();

    expect(find.text('RECHAZADA_SII'), findsNothing);
    expect(find.textContaining('ANULADA'), findsWidgets);
  });

  testWidgets('cajero no ve botón ventas del turno en pantalla vender', (tester) async {
    final composition = PosComposition.memory();
    addTearDown(composition.close);
    await composition.ensureDemoStore();
    await composition.ensureDemoUsers();
    await composition.ensureDemoSeller();
    await composition.authService.login(
      kDemoStoreId,
      const LoginRequest(username: 'usr_cajero', pin: PosComposition.demoPin),
    );
    await composition.shiftService.openShift(
      kDemoStoreId,
      const OpenShiftRequest(openingCashClp: 1000),
    );

    await tester.pumpWidget(
      MaterialApp(home: AppShell(composition: composition)),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('checkout_button')), findsOneWidget);
    expect(find.byKey(const Key('operation_menu_button')), findsNothing);
  });
}