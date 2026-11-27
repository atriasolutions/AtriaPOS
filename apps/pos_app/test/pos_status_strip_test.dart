import 'package:core/application/ports/trusted_clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app/widgets/pos_status_strip.dart';

void main() {
  testWidgets('SC-015-UI-01 reloj visible en franja superior', (tester) async {
    final clock = FakeTrustedClock(DateTime.utc(2026, 3, 18, 15, 0, 0));
    await tester.pumpWidget(
      MaterialApp(
        home: PosStatusStrip(
          clock: clock,
          child: const Scaffold(body: Text('body')),
        ),
      ),
    );
    await tester.pump();
    expect(find.byKey(const Key('pos_clock_label')), findsOneWidget);
    expect(find.text('15:00'), findsOneWidget);
    expect(find.text('18/03/2026'), findsOneWidget);
  });
}