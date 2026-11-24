import 'package:core/api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app/app_shell.dart';
import 'package:pos_app/config/store_config.dart';
import 'package:pos_app/di/pos_composition.dart';

void main() {
  testWidgets('SC-060-02 sin turno muestra abrir turno tras login', (tester) async {
    final composition = PosComposition.memory();
    addTearDown(composition.close);
    await composition.ensureDemoStore();
    await composition.ensureDemoUsers();
    await composition.authService.login(
      kDemoStoreId,
      const LoginRequest(username: 'usr_cajero', pin: PosComposition.demoPin),
    );

    await tester.pumpWidget(
      MaterialApp(home: AppShell(composition: composition)),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('shift_open_button')), findsOneWidget);
  });
}