import 'package:core/api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app/config/store_config.dart';
import 'package:pos_app/di/pos_composition.dart';
import 'package:pos_app/scanner/scanner_ingress.dart';
import 'package:pos_app/screens/product_create_screen.dart';
import 'package:pos_app/screens/stock_receipt_screen.dart';

void main() {
  Future<PosComposition> supervisorComposition({ScannerIngress? ingress}) async {
    final composition = PosComposition.memory(scannerIngress: ingress);
    addTearDown(composition.close);
    if (ingress is StreamScannerIngress) {
      addTearDown(ingress.dispose);
    }
    await composition.ensureDemoStore();
    await composition.ensureDemoUsers();
    await composition.authService.login(
      kDemoStoreId,
      const LoginRequest(username: 'usr_supervisor', pin: PosComposition.demoPin),
    );
    return composition;
  }

  testWidgets('SC-087-UI-01 confirmar ingreso por escaneo', (tester) async {
    final ingress = StreamScannerIngress();
    final composition = await supervisorComposition(ingress: ingress);

    await composition.productService.createProduct(
      kDemoStoreId,
      const CreateProductRequest(
        name: 'Leche',
        salePriceClp: 990,
        initialStock: 4,
        barcode: '78008701',
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: StockReceiptScreen(composition: composition),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('stock_receipt_mode_scan')));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('stock_receipt_guide_field')),
      'GD-SCAN',
    );
    await tester.enterText(
      find.byKey(const Key('stock_receipt_lot_ref_field')),
      'L-SCAN',
    );
    await tester.tap(find.byKey(const Key('stock_receipt_scan_start_button')));
    await tester.pumpAndSettle();

    ingress.push('78008701');
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('stock_receipt_scan_confirm_button')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('stock_receipt_scan_success_snackbar')),
      findsOneWidget,
    );

    final search = await composition.productService.searchProducts(
      kDemoStoreId,
      'Leche',
    );
    final productId =
        (search as ApiSuccess<SearchProductsResponse>).data.items.first.id;
    final stock = await composition.inventoryService.getProductStock(
      kDemoStoreId,
      productId,
    );
    expect(stock, isA<ApiSuccess<StockResponse>>());
    expect((stock as ApiSuccess<StockResponse>).data.stock, 5);
  });

  testWidgets('SC-087-UI-02 modo manual sigue operativo', (tester) async {
    final composition = await supervisorComposition();

    await composition.productService.createProduct(
      kDemoStoreId,
      const CreateProductRequest(
        name: 'Arroz',
        salePriceClp: 900,
        initialStock: 5,
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: StockReceiptScreen(composition: composition),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('stock_receipt_mode_manual')));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('stock_receipt_search_field')),
      'Arr',
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ListTile).first);
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('stock_receipt_quantity_field')),
      '10',
    );
    await tester.enterText(
      find.byKey(const Key('stock_receipt_guide_field')),
      'GD-1',
    );
    await tester.enterText(
      find.byKey(const Key('stock_receipt_lot_ref_field')),
      'L-01',
    );
    await tester.tap(find.byKey(const Key('stock_receipt_submit_button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('stock_receipt_success_snackbar')), findsOneWidget);
  });

  testWidgets('SC-087-UI-03 código desconocido abre crear producto', (tester) async {
    final ingress = StreamScannerIngress();
    final composition = await supervisorComposition(ingress: ingress);

    await tester.pumpWidget(
      MaterialApp(
        home: StockReceiptScreen(composition: composition),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('stock_receipt_mode_scan')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('stock_receipt_guide_field')),
      'G1',
    );
    await tester.enterText(
      find.byKey(const Key('stock_receipt_lot_ref_field')),
      'L1',
    );
    await tester.tap(find.byKey(const Key('stock_receipt_scan_start_button')));
    await tester.pumpAndSettle();

    ingress.push('999UNKNOWN');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Crear producto'));
    await tester.pumpAndSettle();

    expect(find.byType(ProductCreateScreen), findsOneWidget);
    expect(
      find.byKey(const Key('product_create_barcode_field')),
      findsOneWidget,
    );
    final field = tester.widget<TextField>(
      find.byKey(const Key('product_create_barcode_field')),
    );
    expect(field.controller?.text, '999UNKNOWN');
  });

  testWidgets('SC-087-UI-04 confirmar sin líneas muestra error', (tester) async {
    final composition = await supervisorComposition();

    await tester.pumpWidget(
      MaterialApp(
        home: StockReceiptScreen(composition: composition),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('stock_receipt_mode_scan')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('stock_receipt_guide_field')),
      'G2',
    );
    await tester.enterText(
      find.byKey(const Key('stock_receipt_lot_ref_field')),
      'L2',
    );
    await tester.tap(find.byKey(const Key('stock_receipt_scan_start_button')));
    await tester.pumpAndSettle();

    expect(
      tester
          .widget<FilledButton>(
            find.byKey(const Key('stock_receipt_scan_confirm_button')),
          )
          .onPressed,
      isNull,
    );
    expect(find.text('Escanee al menos un producto.'), findsOneWidget);
  });
}