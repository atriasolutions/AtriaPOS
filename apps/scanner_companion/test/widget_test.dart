import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scanner_companion/main.dart';

void main() {
  testWidgets('la puerta es conectar por el enlace del POS', (tester) async {
    await tester.pumpWidget(const ScannerCompanionApp());
    expect(find.byKey(const Key('companion_lan_url_field')), findsOneWidget);
    expect(find.text('Leer QR del POS'), findsOneWidget);
    expect(find.text('Conectar'), findsOneWidget);
  });
}
