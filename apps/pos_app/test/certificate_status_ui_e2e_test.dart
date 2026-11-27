import 'package:core/api/api.dart';
import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app/app_shell.dart';
import 'package:pos_app/config/store_config.dart';
import 'package:pos_app/di/pos_composition.dart';
import 'package:pos_app/screens/sale_screen.dart';

import 'options_navigation_helpers.dart';
import 'wide_viewport.dart';

void main() {
  testWidgets('SC-003-UI-01 supervisor ve estado certificado', (tester) async {
    setWideSaleViewport(tester);
    addTearDown(tester.view.resetPhysicalSize);

    final certs = InMemoryCertificateStore()
      ..info = CertificateInfo(
        subject: 'CN=Piloto',
        validFrom: DateTime.now().toUtc().subtract(const Duration(days: 1)),
        validTo: DateTime.now().toUtc().add(const Duration(days: 365)),
        status: CertificateStatus.valido,
      );
    final composition = PosComposition.memory(certificateStore: certs);
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

    await tester.pumpWidget(
      MaterialApp(home: SaleScreen(composition: composition)),
    );
    await tester.pumpAndSettle();

    await openSaleOptionsScreen(tester);
    await tester.tap(find.byKey(const Key('operation_menu_certificate')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('certificate_status_badge')), findsOneWidget);
    expect(find.text('Válido'), findsOneWidget);
    expect(find.textContaining('CN=Piloto'), findsOneWidget);
    expect(find.byKey(const Key('certificate_valid_to')), findsOneWidget);
  });

  testWidgets('SC-080-PREP-UI-01 guía piloto en pantalla certificado', (tester) async {
    setWideSaleViewport(tester);
    addTearDown(tester.view.resetPhysicalSize);
    final certs = InMemoryCertificateStore()
      ..info = CertificateInfo(
        subject: 'CN=Piloto',
        validFrom: DateTime.now().toUtc().subtract(const Duration(days: 1)),
        validTo: DateTime.now().toUtc().add(const Duration(days: 365)),
        status: CertificateStatus.valido,
      );
    final composition = PosComposition.memory(certificateStore: certs);
    addTearDown(composition.close);
    await composition.ensureDemoStore();
    await composition.ensureDemoUsers();
    await composition.authService.login(
      kDemoStoreId,
      const LoginRequest(username: 'usr_supervisor', pin: PosComposition.demoPin),
    );

    await tester.pumpWidget(
      MaterialApp(home: SaleScreen(composition: composition)),
    );
    await tester.pumpAndSettle();

    await openSaleOptionsScreen(tester);
    await tester.tap(find.byKey(const Key('operation_menu_certificate')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('certificate_pilot_guide')), findsOneWidget);
    expect(find.textContaining('sii-piloto-indice.md'), findsOneWidget);
    expect(find.textContaining('sii-cert-pilot-evidence.md'), findsOneWidget);
  });

  testWidgets('SC-003-UI-02 cajero sin menú certificado', (tester) async {
    final composition = PosComposition.memory();
    addTearDown(composition.close);
    await composition.ensureDemoStore();
    await composition.ensureDemoUsers();
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

    final menuButton = find.byKey(const Key('operation_menu_button'));
    if (menuButton.evaluate().isNotEmpty) {
      await tester.tap(menuButton);
      await tester.pumpAndSettle();
    }
    expect(find.byKey(const Key('operation_menu_certificate')), findsNothing);
  });
}