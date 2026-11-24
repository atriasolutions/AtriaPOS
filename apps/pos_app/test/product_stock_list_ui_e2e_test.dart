import 'package:core/api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app/config/store_config.dart';
import 'package:pos_app/di/pos_composition.dart';
import 'package:pos_app/screens/product_stock_list_screen.dart';

void main() {
  testWidgets('SC-079-UI-01 lista stock y botón PRODUCTOS', (tester) async {
    final composition = PosComposition.memory();
    addTearDown(composition.close);
    await composition.ensureDemoStore();
    await composition.ensureDemoUsers();
    await composition.authService.login(
      kDemoStoreId,
      const LoginRequest(username: 'usr_supervisor', pin: PosComposition.demoPin),
    );
    await composition.productService.createProduct(
      kDemoStoreId,
      const CreateProductRequest(
        name: 'Harina',
        salePriceClp: 800,
        initialStock: 12,
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ProductStockListScreen(composition: composition),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('product_stock_list')), findsOneWidget);
    expect(find.textContaining('Harina'), findsOneWidget);
    expect(find.textContaining('stock 12'), findsOneWidget);
  });

  testWidgets('SC-084-UI-01 supervisor ve Nuevo producto en stock', (tester) async {
    final composition = PosComposition.memory();
    addTearDown(composition.close);
    await composition.ensureDemoStore();
    await composition.ensureDemoUsers();
    await composition.authService.login(
      kDemoStoreId,
      const LoginRequest(username: 'usr_supervisor', pin: PosComposition.demoPin),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ProductStockListScreen(composition: composition),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('product_stock_new_button')), findsOneWidget);
  });

  testWidgets('SC-084-UI-02 cajero sin Nuevo producto en stock', (tester) async {
    final composition = PosComposition.memory();
    addTearDown(composition.close);
    await composition.ensureDemoStore();
    await composition.ensureDemoUsers();
    await composition.authService.login(
      kDemoStoreId,
      const LoginRequest(username: 'usr_cajero', pin: PosComposition.demoPin),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ProductStockListScreen(composition: composition),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('product_stock_new_button')), findsNothing);
  });

  testWidgets('SC-084-UI-03 abre pantalla crear producto', (tester) async {
    final composition = PosComposition.memory();
    addTearDown(composition.close);
    await composition.ensureDemoStore();
    await composition.ensureDemoUsers();
    await composition.authService.login(
      kDemoStoreId,
      const LoginRequest(username: 'usr_dueno', pin: PosComposition.demoPin),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ProductStockListScreen(composition: composition),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('product_stock_new_button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('product_create_name_field')), findsOneWidget);
  });
}