import 'package:core/api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app/config/store_config.dart';
import 'package:pos_app/di/pos_composition.dart';
import 'package:pos_app/screens/sale_screen.dart';

Future<void> _checkoutSale(
  PosComposition composition,
  String productId,
  int priceClp,
) async {
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
      payments: [CheckoutPaymentDto(method: 'EFECTIVO', amountClp: priceClp)],
      changeClp: 0,
    ),
  );
}

void main() {
  testWidgets('SC-060-UI-01 reporte ventas del día', (tester) async {
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
        name: 'Item A',
        salePriceClp: 1000,
        initialStock: 10,
      ),
    );
    final productId = (product as ApiSuccess<ProductResponse>).data.id;
    final productB = await composition.productService.createProduct(
      kDemoStoreId,
      const CreateProductRequest(
        name: 'Item B',
        salePriceClp: 1500,
        initialStock: 10,
      ),
    );
    final productIdB = (productB as ApiSuccess<ProductResponse>).data.id;

    await _checkoutSale(composition, productId, 1000);
    await _checkoutSale(composition, productIdB, 1500);

    await tester.pumpWidget(
      MaterialApp(
        home: SaleScreen(composition: composition),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('operation_menu_button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('operation_menu_daily_report')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('daily_report_total')), findsOneWidget);
    expect(find.text('\$2500'), findsOneWidget);
    expect(find.byKey(const Key('daily_report_count')), findsOneWidget);
    expect(find.text('2'), findsWidgets);
    expect(find.byKey(const Key('daily_report_average')), findsOneWidget);
    expect(find.text('\$1250'), findsOneWidget);
  });
}