import 'package:core/api/api.dart';
import 'package:core/application/application.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app/config/store_config.dart';
import 'package:pos_app/di/pos_composition.dart';
import 'package:pos_app/screens/dte_queue_screen.dart';

void main() {
  testWidgets('SC-051-UI-01 cola DTE y reintento', (tester) async {
    final composition = PosComposition.memory(
      dteGateway: FakeDteGateway(mode: FakeDteMode.failOnceThenSuccess),
    );
    addTearDown(composition.close);
    await composition.ensureDemoStore();
    await composition.ensureDemoUsers();
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
        name: 'Item',
        salePriceClp: 1000,
        initialStock: 5,
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
    final checkout = await composition.saleService.checkout(
      kDemoStoreId,
      cartId,
      const CheckoutRequest(
        payments: [CheckoutPaymentDto(method: 'EFECTIVO', amountClp: 1000)],
        changeClp: 0,
      ),
    );
    final saleId = (checkout as ApiSuccess<CheckoutResponse>).data.saleId;

    await tester.pumpWidget(
      MaterialApp(
        home: DteQueueScreen(composition: composition),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(Key('dte_queue_tile_$saleId')), findsOneWidget);

    await tester.tap(find.byKey(const Key('dte_retry_button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('dte_retry_snackbar')), findsOneWidget);
    expect(find.text('No hay boletas pendientes.'), findsOneWidget);
  });
}