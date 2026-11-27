import 'package:core/api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app/config/store_config.dart';
import 'package:pos_app/di/pos_composition.dart';
import 'package:pos_app/scanner/scanner_ingress.dart';
import 'package:pos_app/screens/inventory_close_screen.dart';
import 'package:pos_app/screens/product_create_screen.dart';

Future<void> _seedShiftOpen(PosComposition composition) async {
  await composition.ensureDemoStore();
  await composition.ensureDemoUsers();
  await composition.authService.login(
    kDemoStoreId,
    const LoginRequest(
      username: 'usr_supervisor',
      pin: PosComposition.demoPin,
    ),
  );
  await composition.shiftService.openShift(
    kDemoStoreId,
    const OpenShiftRequest(openingCashClp: 0),
  );
}

void main() {
  Future<PosComposition> supervisorComposition({ScannerIngress? ingress}) async {
    final composition = PosComposition.memory(scannerIngress: ingress);
    addTearDown(composition.close);
    if (ingress is StreamScannerIngress) {
      addTearDown(ingress.dispose);
    }
    await _seedShiftOpen(composition);
    return composition;
  }

  testWidgets('SC-088-SCAN-UI-01 confirmar conteo por escaneo', (tester) async {
    final ingress = StreamScannerIngress();
    final composition = await supervisorComposition(ingress: ingress);

    await composition.productService.createProduct(
      kDemoStoreId,
      const CreateProductRequest(
        name: 'Arroz',
        salePriceClp: 1200,
        initialStock: 10,
        barcode: '78008801',
      ),
    );

    await tester.pumpWidget(
      MaterialApp(home: InventoryCloseScreen(composition: composition)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('inventory_close_mode_scan')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('inventory_close_scan_start_button')));
    await tester.pumpAndSettle();

    ingress.push('78008801');
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('inventory_close_scan_catalog')), findsOneWidget);
    expect(find.text('Diferencias'), findsOneWidget);

    await tester.tap(find.byKey(const Key('inventory_close_scan_confirm_button')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('inventory_close_scan_success_snackbar')),
      findsOneWidget,
    );

    final search = await composition.productService.searchProducts(
      kDemoStoreId,
      'Arroz',
    );
    final productId =
        (search as ApiSuccess<SearchProductsResponse>).data.items.first.id;
    final stock = await composition.inventoryService.getProductStock(
      kDemoStoreId,
      productId,
    );
    expect(stock, isA<ApiSuccess<StockResponse>>());
    expect((stock as ApiSuccess<StockResponse>).data.stock, 1);
  });

  testWidgets('SC-155-UI-01 escaneo muestra diferencia en rojo', (tester) async {
    final ingress = StreamScannerIngress();
    final composition = await supervisorComposition(ingress: ingress);

    final created = await composition.productService.createProduct(
      kDemoStoreId,
      const CreateProductRequest(
        name: 'Aceite',
        salePriceClp: 2000,
        initialStock: 10,
        barcode: '78009901',
      ),
    );
    final productId = (created as ApiSuccess<ProductResponse>).data.id;

    await tester.pumpWidget(
      MaterialApp(home: InventoryCloseScreen(composition: composition)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('inventory_close_mode_scan')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('inventory_close_scan_start_button')));
    await tester.pumpAndSettle();

    ingress.push('78009901');
    await tester.pumpAndSettle();

    expect(find.text('Diferencias'), findsOneWidget);
    expect(find.byKey(Key('inventory_line_delta_$productId')), findsOneWidget);
    expect(
      find.byKey(Key('inventory_line_status_$productId')),
      findsOneWidget,
    );
  });

  testWidgets('SC-088-SCAN-UI-02 modo manual sigue operativo', (tester) async {
    final composition = await supervisorComposition();

    final product = await composition.productService.createProduct(
      kDemoStoreId,
      const CreateProductRequest(
        name: 'Fideos',
        salePriceClp: 800,
        initialStock: 12,
      ),
    );
    final productId = (product as ApiSuccess<ProductResponse>).data.id;

    await tester.pumpWidget(
      MaterialApp(home: InventoryCloseScreen(composition: composition)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('inventory_close_mode_scan')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('inventory_close_mode_manual')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('inventory_close_list')), findsOneWidget);
    await tester.enterText(
      find.byKey(Key('inventory_close_count_$productId')),
      '11',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('inventory_close_submit_button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('inventory_close_success')), findsOneWidget);
  });

  testWidgets('SC-088-SCAN-UI-03 código desconocido abre crear producto',
      (tester) async {
    final composition = await supervisorComposition();

    await tester.pumpWidget(
      MaterialApp(home: InventoryCloseScreen(composition: composition)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('inventory_close_mode_scan')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('inventory_close_scan_start_button')));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('inventory_close_scan_code_field')),
      '888NOEXISTE',
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Crear producto'));
    await tester.pumpAndSettle();

    expect(find.byType(ProductCreateScreen), findsOneWidget);
    expect(find.byKey(const Key('product_create_name_field')), findsOneWidget);
  });

  testWidgets('SC-088-SCAN-UI-04 confirmar sin líneas muestra error',
      (tester) async {
    final composition = await supervisorComposition();

    await tester.pumpWidget(
      MaterialApp(home: InventoryCloseScreen(composition: composition)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('inventory_close_mode_scan')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('inventory_close_scan_start_button')));
    await tester.pumpAndSettle();

    expect(
      tester
          .widget<FilledButton>(
            find.byKey(const Key('inventory_close_scan_confirm_button')),
          )
          .onPressed,
      isNull,
    );
    expect(find.text('Escanee al menos un producto.'), findsOneWidget);
  });
}