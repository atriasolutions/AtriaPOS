import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app/config/store_config.dart';
import 'package:pos_app/di/pos_composition.dart';
import 'package:pos_app/screens/login_screen.dart';
import 'package:pos_app/screens/sale_screen.dart';
import 'package:core/api/api.dart';

import 'wide_viewport.dart';

void main() {
  Future<void> openUsersMenu(WidgetTester tester, PosComposition composition) async {
    await composition.authService.login(
      kDemoStoreId,
      const LoginRequest(username: 'usr_dueno', pin: PosComposition.demoPin),
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
  }

  testWidgets('SC-080-UI-01 dueño ve lista usuarios', (tester) async {
    setWideSaleViewport(tester);
    addTearDown(tester.view.resetPhysicalSize);

    final composition = PosComposition.memory();
    addTearDown(composition.close);
    await composition.ensureDemoStore();
    await composition.ensureDemoUsers();

    await openUsersMenu(tester, composition);

    expect(find.byKey(const Key('users_list_add_fab')), findsOneWidget);
    expect(find.text('Cajero Demo'), findsWidgets);
  });

  testWidgets('SC-080-UI-02 edita apellido desde UI', (tester) async {
    final composition = PosComposition.memory();
    addTearDown(composition.close);
    await composition.ensureDemoStore();
    await composition.ensureDemoUsers();

    await openUsersMenu(tester, composition);

    await tester.tap(find.text('Cajero Demo'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('user_edit_last_name_field')),
      'Editado',
    );
    await tester.tap(find.byKey(const Key('user_edit_submit_button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('user_edit_success_snackbar')), findsOneWidget);
    expect(find.text('Cajero Editado'), findsOneWidget);
  });

  testWidgets('SC-080-UI-03 cambia PIN y login', (tester) async {
    const newPin = '8642';
    final composition = PosComposition.memory();
    addTearDown(composition.close);
    await composition.ensureDemoStore();
    await composition.ensureDemoUsers();

    await openUsersMenu(tester, composition);

    await tester.tap(find.text('Cajero Demo'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('user_edit_pin_field')),
      newPin,
    );
    await tester.tap(find.byKey(const Key('user_edit_submit_button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

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
      'usr_cajero',
    );
    await tester.enterText(
      find.byKey(const Key('login_pin_field')),
      newPin,
    );
    await tester.tap(find.byKey(const Key('login_button')));
    await tester.pumpAndSettle();

    expect(loggedIn, isTrue);
  });

  testWidgets('SC-080-UI-04 supervisor sin menú Usuarios', (tester) async {
    final composition = PosComposition.memory();
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

    expect(find.byKey(const Key('operation_menu_users')), findsNothing);
  });
}