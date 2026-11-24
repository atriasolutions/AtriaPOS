import 'package:core/api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app/config/store_config.dart';
import 'package:pos_app/di/pos_composition.dart';
import 'package:pos_app/screens/stock_insights_screen.dart';

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
      sellerCode: 'V01',
      payments: [CheckoutPaymentDto(method: 'EFECTIVO', amountClp: priceClp)],
      changeClp: 0,
    ),
  );
}

void main() {
  testWidgets('SC-087-UI-01 stock bajo en pantalla', (tester) async {
    final composition = PosComposition.memory();
    addTearDown(composition.close);
    await composition.ensureDemoStore();
    await composition.ensureDemoUsers();
    await composition.authService.login(
      kDemoStoreId,
      const LoginRequest(username: 'usr_supervisor', pin: PosComposition.demoPin),
    );
    final created = await composition.productService.createProduct(
      kDemoStoreId,
      const CreateProductRequest(
        name: 'Pan hallulla',
        salePriceClp: 500,
        initialStock: 2,
      ),
    );
    final productId = (created as ApiSuccess<ProductResponse>).data.id;

    await tester.pumpWidget(
      MaterialApp(
        home: StockInsightsScreen(composition: composition),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('stock_insights_as_of')), findsOneWidget);
    expect(find.byKey(Key('stock_insights_low_$productId')), findsOneWidget);
    expect(find.text('Pan hallulla'), findsOneWidget);
  });

  testWidgets('SC-087-UI-02 top sellers tras venta', (tester) async {
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
      const OpenShiftRequest(openingCashClp: 0),
    );
    final created = await composition.productService.createProduct(
      kDemoStoreId,
      const CreateProductRequest(
        name: 'Bebida cola',
        salePriceClp: 800,
        initialStock: 20,
      ),
    );
    final productId = (created as ApiSuccess<ProductResponse>).data.id;
    await _checkoutSale(composition, productId, 800);

    await tester.pumpWidget(
      MaterialApp(
        home: StockInsightsScreen(composition: composition),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(Key('stock_insights_top_$productId')), findsOneWidget);
    expect(find.textContaining('1 u.'), findsWidgets);
  });
}