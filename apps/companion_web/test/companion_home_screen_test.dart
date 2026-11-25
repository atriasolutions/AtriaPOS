import 'package:companion_web/companion_client.dart';
import 'package:companion_web/companion_home_screen.dart';
import 'package:core/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

class _RecordingClient extends CompanionClient {
  _RecordingClient() : super(http.Client());

  final List<String> scans = [];

  @override
  Future<void> pair(CompanionLaunchParams params) async {
    token = 'test-token';
  }

  @override
  Future<void> sendScan(String code) async {
    scans.add(code);
  }
}

Widget _fakeCamera({
  required bool enabled,
  required Future<void> Function(String code) onCode,
}) {
  return Column(
    key: const Key('companion_camera_fake'),
    children: [
      FilledButton(
        key: const Key('companion_camera_fake_scan'),
        onPressed: enabled ? () => onCode('999888777') : null,
        child: const Text('Simular escaneo'),
      ),
    ],
  );
}

Uri _launchUri() => Uri.parse(
      'http://192.168.0.10:8765/companion/?storeId=t1&mode=VENDER&pairingCode=ABC123',
    );

void main() {
  testWidgets('SC-108-03 sin tienda ni emparejar manual tras auto-pair', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: CompanionHomeScreen(
          launchUri: _launchUri(),
          pairFn: (_) async => _RecordingClient(),
          cameraBuilder: _fakeCamera,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('companion_pair_button')), findsNothing);
    expect(find.textContaining('Tienda:'), findsNothing);
    expect(find.byKey(const Key('companion_mode_label')), findsOneWidget);
    expect(find.text('Modo: Vender'), findsOneWidget);
  });

  testWidgets('SC-108-04 formulario manual activo al conectar', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: CompanionHomeScreen(
          launchUri: _launchUri(),
          pairFn: (_) async => _RecordingClient(),
          cameraBuilder: _fakeCamera,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('companion_manual_code_field')), findsOneWidget);
    final button = tester.widget<FilledButton>(
      find.byKey(const Key('companion_send_scan_button')),
    );
    expect(button.onPressed, isNotNull);
  });

  testWidgets('SC-108-06 sin query no muestra escaneo', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: CompanionHomeScreen(
          launchUri: Uri.parse('http://localhost:8765/companion/'),
          cameraBuilder: _fakeCamera,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('companion_manual_code_field')), findsNothing);
    expect(find.byKey(const Key('companion_send_scan_button')), findsNothing);
    expect(find.byKey(const Key('companion_status_label')), findsOneWidget);
    expect(find.textContaining('QR'), findsOneWidget);
  });

  testWidgets('SC-110-04 cámara fake envía escaneo por WS', (tester) async {
    final client = _RecordingClient();
    await tester.pumpWidget(
      MaterialApp(
        home: CompanionHomeScreen(
          launchUri: _launchUri(),
          pairFn: (_) async => client,
          cameraBuilder: _fakeCamera,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('companion_camera_fake')), findsOneWidget);
    await tester.tap(find.byKey(const Key('companion_camera_fake_scan')));
    await tester.pumpAndSettle();

    expect(client.scans, ['999888777']);
    expect(find.textContaining('Enviado: 999888777'), findsOneWidget);
  });

  testWidgets('SC-110-05 manual visible junto a cámara', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: CompanionHomeScreen(
          launchUri: _launchUri(),
          pairFn: (_) async => _RecordingClient(),
          cameraBuilder: _fakeCamera,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('companion_camera_fake')), findsOneWidget);
    expect(find.byKey(const Key('companion_manual_code_field')), findsOneWidget);
    expect(find.byKey(const Key('companion_send_scan_button')), findsOneWidget);
  });
}