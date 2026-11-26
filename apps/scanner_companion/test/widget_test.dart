import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scanner_companion/companion_ui_strings.dart';
import 'package:scanner_companion/main.dart';

void main() {
  testWidgets('la puerta es conectar a la caja', (tester) async {
    await tester.pumpWidget(const ScannerCompanionApp());
    expect(find.text(companionConnectTitle), findsOneWidget);
    expect(find.text(companionReadBoxCodeButtonLabel), findsOneWidget);
    expect(find.byKey(const Key('companion_lan_url_field')), findsNothing);
    expect(find.textContaining('POS'), findsNothing);
  });
}