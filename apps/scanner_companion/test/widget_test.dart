import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scanner_companion/main.dart';

void main() {
  testWidgets('muestra pantalla de pareo', (tester) async {
    await tester.pumpWidget(const ScannerCompanionApp());
    expect(find.textContaining('código'), findsWidgets);
    expect(find.byKey(const Key('companion_pairing_code_field')), findsOneWidget);
  });
}