import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app/config/store_config.dart';
import 'package:pos_app/di/pos_composition.dart';
import 'package:pos_app/screens/login_screen.dart';
import 'package:pos_app/screens/sale_screen.dart';
import 'package:core/api/api.dart';

void main() {
  const newUserId = 'usr_nuevo_cajero';
  const newPin = '1357';

  testWidgets('SC-070-UI-01 dueño crea cajero y puede iniciar sesión', (tester) async {
    final composition = PosComposition.memory();
    addTearDown(composition.close);
    await composition.ensureDemoStore();
    await composition.ensureDemoUsers();
    await composition.authService.login(
      kDemoStoreId,
      const LoginRequest(userId: 'usr_dueno', pin: PosComposition.demoPin),
    );
    await composition.shiftService.openShift(
      kDemoStoreId,
      const OpenShiftRequest(openingCashClp: 0),
    );

    await tester.pumpWidget(
      MaterialApp(home: SaleScreen(composition: composition)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('operation_menu_button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('operation_menu_users')));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('user_create_id_field')),
      newUserId,
    );
    await tester.enterText(
      find.byKey(const Key('user_create_name_field')),
      'Cajero nuevo',
    );
    await tester.enterText(
      find.byKey(const Key('user_create_pin_field')),
      newPin,
    );
    await tester.tap(find.byKey(const Key('user_create_submit_button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('user_create_success_snackbar')), findsOneWidget);

    composition.sessionProvider.clear();
    var loggedIn = false;
    await tester.pumpWidget(
      MaterialApp(
        home: LoginScreen(
          composition: composition,
          onLoggedIn: () => loggedIn = true,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('login_user_id_field')),
      newUserId,
    );
    await tester.enterText(
      find.byKey(const Key('login_pin_field')),
      newPin,
    );
    await tester.tap(find.byKey(const Key('login_button')));
    await tester.pumpAndSettle();

    expect(loggedIn, isTrue);
    expect(composition.sessionProvider.current?.role.name, 'cajero');
  });

  testWidgets('SC-070-UI-02 supervisor sin menú nuevo usuario', (tester) async {
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

    await tester.pumpWidget(
      MaterialApp(home: SaleScreen(composition: composition)),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('operation_menu_users')), findsNothing);
  });
}