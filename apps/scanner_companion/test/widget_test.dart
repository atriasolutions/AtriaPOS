import 'package:flutter_test/flutter_test.dart';
import 'package:scanner_companion/main.dart';

void main() {
  testWidgets('muestra pantalla escáner', (tester) async {
    await tester.pumpWidget(const ScannerCompanionApp());
    expect(find.textContaining('cámara'), findsOneWidget);
  });
}