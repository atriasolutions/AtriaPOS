import 'package:core/application/ports/trusted_clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app/widgets/pos_clock_overlay.dart';

void main() {
  testWidgets('SC-015-UI-01 reloj visible', (tester) async {
    final clock = FakeTrustedClock(DateTime.utc(2026, 3, 18, 15, 0, 0));
    await tester.pumpWidget(
      MaterialApp(
        home: PosClockOverlay(
          clock: clock,
          child: const Scaffold(body: Text('body')),
        ),
      ),
    );
    await tester.pump();
    expect(find.byKey(const Key('pos_clock_label')), findsOneWidget);
  });
}