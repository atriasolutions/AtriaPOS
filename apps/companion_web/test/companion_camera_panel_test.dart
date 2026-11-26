import 'package:companion_web/companion_camera_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('SC-110-06 sin visor 220 si cámara no disponible', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CompanionCameraPanel(
            enabled: true,
            startUnavailable: true,
            onDetect: (_) {},
          ),
        ),
      ),
    );

    expect(find.byKey(const Key('companion_camera_scanner')), findsNothing);
    expect(find.byKey(const Key('companion_camera_unavailable')), findsOneWidget);
    expect(tester.getSize(find.byType(CompanionCameraPanel)).height, lessThan(100));
  });
}