import 'package:core/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app/config/store_config.dart';
import 'package:pos_app/di/pos_composition.dart';
import 'package:pos_app/screens/store_setup_screen.dart';

void main() {
  testWidgets('SC-001-UI-01 onboarding crea tienda', (tester) async {
    final composition = PosComposition.memory();
    addTearDown(composition.close);
    await composition.refreshActiveStore();
    expect(composition.activeStoreId, isNull);

    var completed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: StoreSetupScreen(
          composition: composition,
          onCompleted: () => completed = true,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('store_setup_rut_field')),
      '12.345.678-5',
    );
    await tester.enterText(
      find.byKey(const Key('store_setup_legal_name_field')),
      'Minimarket Sur',
    );
    await tester.enterText(
      find.byKey(const Key('store_setup_giro_field')),
      'Almacén',
    );
    await tester.enterText(
      find.byKey(const Key('store_setup_owner_first_name_field')),
      'Dueño',
    );
    await tester.enterText(
      find.byKey(const Key('store_setup_owner_last_name_field')),
      'Tienda',
    );
    await tester.enterText(
      find.byKey(const Key('store_setup_owner_username_field')),
      'jperez',
    );
    await tester.enterText(
      find.byKey(const Key('store_setup_owner_rut_field')),
      '12.345.678-5',
    );
    await tester.enterText(
      find.byKey(const Key('store_setup_pin_field')),
      PosComposition.demoPin,
    );
    await tester.ensureVisible(find.byKey(const Key('store_setup_submit_button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('store_setup_submit_button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('store_setup_success_snackbar')), findsOneWidget);
    expect(completed, isTrue);
    expect(composition.activeStoreId, isNotNull);
    expect(composition.activeStoreId, isNot(kDemoStoreId));
    expect(composition.sessionProvider.current?.role, UserRole.dueno);
  });
}