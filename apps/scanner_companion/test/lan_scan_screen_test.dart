import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scanner_companion/companion_lan_client.dart';
import 'package:scanner_companion/lan_scan_screen.dart';

class _Sink implements CompanionScanSink {
  final messages = <String>[];

  @override
  void add(String text) => messages.add(text);
}

void main() {
  final now = DateTime.utc(2026, 11, 25, 12);

  CompanionLanSession session(_Sink sink) {
    return CompanionLanSession(
      sink: sink,
      modeApi: 'VENDER',
      token: 'tok',
      storeId: 't',
    );
  }

  testWidgets('SC-120-01 dos lecturas iguales envían una vez', (tester) async {
    final sink = _Sink();
    await tester.pumpWidget(
      MaterialApp(
        home: LanScanScreen(
          session: session(sink),
          now: () => now,
          camera: (onCode) => TextButton(
            onPressed: () => onCode('7801'),
            child: const Text('leer'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('leer'));
    await tester.pump();
    await tester.tap(find.text('leer'));
    await tester.pump();
    expect(sink.messages, hasLength(1));
  });

  testWidgets('SC-120-02 códigos distintos se envían ambos', (tester) async {
    final sink = _Sink();
    var flip = false;
    await tester.pumpWidget(
      MaterialApp(
        home: LanScanScreen(
          session: session(sink),
          now: () => now,
          camera: (onCode) => TextButton(
            onPressed: () {
              flip = !flip;
              onCode(flip ? '111' : '222');
            },
            child: const Text('leer'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('leer'));
    await tester.pump();
    await tester.tap(find.text('leer'));
    await tester.pump();
    expect(sink.messages, hasLength(2));
  });
}
