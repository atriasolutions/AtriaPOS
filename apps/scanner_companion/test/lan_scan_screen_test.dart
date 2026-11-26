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

  Future<void> pumpScan(
    WidgetTester tester, {
    required _Sink sink,
    required void Function(void Function(String code) onCode) bindCamera,
  }) async {
    late void Function(String code) onCode;
    await tester.pumpWidget(
      MaterialApp(
        home: LanScanScreen(
          session: session(sink),
          now: () => now,
          camera: (callback) {
            onCode = callback;
            return TextButton(
              onPressed: () => bindCamera(onCode),
              child: const Text('leer'),
            );
          },
        ),
      ),
    );
  }

  testWidgets('SC-134-02 iconos en pantalla de trabajo', (tester) async {
    final sink = _Sink();
    await tester.pumpWidget(
      MaterialApp(
        home: LanScanScreen(
          session: session(sink),
          now: () => now,
          camera: (_) => const SizedBox(),
        ),
      ),
    );
    expect(find.byIcon(Icons.logout), findsOneWidget);
    expect(find.byIcon(Icons.document_scanner), findsOneWidget);
    expect(find.byKey(const Key('companion_lan_send_scan_button')), findsOneWidget);
  });

  testWidgets('SC-120-01 dos lecturas iguales sin toque no envían', (
    tester,
  ) async {
    final sink = _Sink();
    await pumpScan(
      tester,
      sink: sink,
      bindCamera: (onCode) => onCode('7801'),
    );
    await tester.tap(find.text('leer'));
    await tester.pump();
    await tester.tap(find.text('leer'));
    await tester.pump();
    expect(sink.messages, isEmpty);
  });

  testWidgets('SC-120-02 dos códigos distintos sin toque no envían', (
    tester,
  ) async {
    final sink = _Sink();
    var flip = false;
    await pumpScan(
      tester,
      sink: sink,
      bindCamera: (onCode) {
        flip = !flip;
        onCode(flip ? '111' : '222');
      },
    );
    await tester.tap(find.text('leer'));
    await tester.pump();
    await tester.tap(find.text('leer'));
    await tester.pump();
    expect(sink.messages, isEmpty);
  });

  testWidgets('SC-131-01 detecciones sin Escanear no envían al POS', (
    tester,
  ) async {
    final sink = _Sink();
    await pumpScan(
      tester,
      sink: sink,
      bindCamera: (onCode) => onCode('7801'),
    );
    await tester.tap(find.text('leer'));
    await tester.pump();
    await tester.tap(find.text('leer'));
    await tester.pump();
    expect(sink.messages, isEmpty);
  });

  testWidgets('SC-131-02 Escanear envía una vez; segundo toque no duplica', (
    tester,
  ) async {
    final sink = _Sink();
    await pumpScan(
      tester,
      sink: sink,
      bindCamera: (onCode) => onCode('7801'),
    );
    await tester.tap(find.text('leer'));
    await tester.pump();
    await tester.tap(find.byKey(const Key('companion_lan_send_scan_button')));
    await tester.pump();
    expect(sink.messages, hasLength(1));
    await tester.tap(find.byKey(const Key('companion_lan_send_scan_button')));
    await tester.pump();
    expect(sink.messages, hasLength(1));
  });

  testWidgets('SC-131-03 dos productos: detectar, enviar, detectar, enviar', (
    tester,
  ) async {
    final sink = _Sink();
    var flip = false;
    await pumpScan(
      tester,
      sink: sink,
      bindCamera: (onCode) {
        flip = !flip;
        onCode(flip ? '111' : '222');
      },
    );
    await tester.tap(find.text('leer'));
    await tester.pump();
    await tester.tap(find.byKey(const Key('companion_lan_send_scan_button')));
    await tester.pump();
    await tester.tap(find.text('leer'));
    await tester.pump();
    await tester.tap(find.byKey(const Key('companion_lan_send_scan_button')));
    await tester.pump();
    expect(sink.messages, hasLength(2));
  });

  testWidgets('SC-131-04 Escanear sin detección no envía', (tester) async {
    final sink = _Sink();
    await pumpScan(
      tester,
      sink: sink,
      bindCamera: (onCode) => onCode('7801'),
    );
    final button = tester.widget<FilledButton>(
      find.byKey(const Key('companion_lan_send_scan_button')),
    );
    expect(button.onPressed, isNull);
    expect(sink.messages, isEmpty);
    expect(find.byKey(const Key('companion_lan_scan_status')), findsOneWidget);
  });

  testWidgets('SC-135-01 Escanear deshabilitado sin detección', (tester) async {
    final sink = _Sink();
    await pumpScan(
      tester,
      sink: sink,
      bindCamera: (onCode) => onCode('7801'),
    );
    final button = tester.widget<FilledButton>(
      find.byKey(const Key('companion_lan_send_scan_button')),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('SC-138-01 código manual bajo Escribir código', (tester) async {
    final sink = _Sink();
    await pumpScan(
      tester,
      sink: sink,
      bindCamera: (_) {},
    );
    expect(find.byKey(const Key('companion_lan_manual_code_field')), findsNothing);
    await tester.tap(find.text('Escribir código'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('companion_lan_manual_code_field')), findsOneWidget);
  });

  testWidgets('SC-138-02 enviar código manual llega al POS', (tester) async {
    final sink = _Sink();
    await pumpScan(
      tester,
      sink: sink,
      bindCamera: (_) {},
    );
    await tester.tap(find.text('Escribir código'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('companion_lan_manual_code_field')),
      '1234567890',
    );
    await tester.tap(find.byKey(const Key('companion_lan_manual_send_button')));
    await tester.pump();
    expect(sink.messages, hasLength(1));
    expect(sink.messages.single, contains('1234567890'));
    expect(find.textContaining('Último: 1234567890'), findsOneWidget);
  });

  testWidgets('SC-135-02 Escanear habilitado tras lectura', (tester) async {
    final sink = _Sink();
    await pumpScan(
      tester,
      sink: sink,
      bindCamera: (onCode) => onCode('7801'),
    );
    await tester.tap(find.text('leer'));
    await tester.pump();
    final button = tester.widget<FilledButton>(
      find.byKey(const Key('companion_lan_send_scan_button')),
    );
    expect(button.onPressed, isNotNull);
    expect(find.byKey(const Key('companion_lan_scan_ready_chip')), findsOneWidget);
  });
}
