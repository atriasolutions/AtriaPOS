import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app/di/pos_composition.dart';
import 'package:pos_app/main.dart';
import 'package:pos_app/screens/shift_open_screen.dart';

void main() {
  testWidgets('pantalla abrir turno', (WidgetTester tester) async {
    final composition = PosComposition.memory();
    addTearDown(composition.close);
    await composition.ensureDemoStore();

    await tester.pumpWidget(
      MaterialApp(
        home: ShiftOpenScreen(composition: composition),
      ),
    );

    expect(find.text('Abrir turno'), findsWidgets);
    expect(find.byKey(const Key('shift_open_button')), findsOneWidget);
  });
}