import 'package:core/api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app/config/store_config.dart';
import 'package:pos_app/di/pos_composition.dart';
import 'package:pos_app/screens/close_shift_screen.dart';
import 'package:pos_app/screens/sale_screen.dart';

void main() {
  testWidgets('SC-041-UI-01 cierre de caja con venta efectivo', (tester) async {
    final composition = PosComposition.memory();
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
      const OpenShiftRequest(openingCashClp: 50000),
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
    await composition.saleService.checkout(
      kDemoStoreId,
      cartId,
      const CheckoutRequest(
        sellerCode: 'V01',
        payments: [CheckoutPaymentDto(method: 'EFECTIVO', amountClp: 1000)],
        changeClp: 0,
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: CloseShiftScreen(composition: composition),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('close_shift_counted_field')),
      '51000',
    );
    await tester.tap(find.byKey(const Key('close_shift_confirm_button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('close_shift_report_dialog')), findsOneWidget);
    expect(find.textContaining('Diferencia: \$0'), findsOneWidget);
    expect(find.textContaining('Total ventas: \$1000'), findsOneWidget);

    await tester.tap(find.byKey(const Key('close_shift_report_ok')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('shift_open_button')), findsOneWidget);
  });

  testWidgets('SC-041-UI-03 cierre sin turno abierto', (tester) async {
    final composition = PosComposition.memory();
    addTearDown(composition.close);
    await composition.ensureDemoStore();
    await composition.ensureDemoUsers();
    await composition.ensureDemoSeller();
    await composition.authService.login(
      kDemoStoreId,
      const LoginRequest(username: 'usr_supervisor', pin: PosComposition.demoPin),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: SaleScreen(composition: composition),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('operation_menu_button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('operation_menu_close')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('close_shift_no_open_message')), findsOneWidget);
    expect(find.byKey(const Key('close_shift_confirm_button')), findsNothing);
  });

  testWidgets('SC-041-UI-02 cajero no ve menú operación en vender', (tester) async {
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
      MaterialApp(
        home: SaleScreen(composition: composition),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('operation_menu_button')), findsNothing);
    expect(find.byKey(const Key('operation_menu_close')), findsNothing);
  });
}