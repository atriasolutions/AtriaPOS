import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scanner_companion/companion_camera_view.dart';
import 'package:scanner_companion/companion_lan_client.dart';
import 'package:scanner_companion/lan_connect_screen.dart';

class _Sink implements CompanionScanSink {
  @override
  void add(String text) {}
}

class _Gateway implements CompanionPosGateway {
  _Gateway(this.location);

  final Uri? location;

  @override
  Future<CompanionScanSink> connectWs(Uri wsUri) async => _Sink();

  @override
  Future<Uri?> getShortLinkLocation(Uri shortUri) async => location;

  @override
  Future<Map<String, dynamic>> postPair(
    Uri pairUri,
    Map<String, Object?> body,
  ) async {
    return {'token': 'tok', 'wsPath': '/v0/ws/companion'};
  }
}

void main() {
  testWidgets('SC-119-01 conectar muestra el modo Vender', (tester) async {
    final client = CompanionLanClient(
      (_) => _Gateway(
        Uri.parse(
          'https://10.0.0.8:8765/companion/?storeId=t&mode=VENDER&pairingCode=ABCDEF',
        ),
      ),
    );
    await tester.pumpWidget(
      MaterialApp(home: LanConnectScreen(client: client)),
    );
    await tester.enterText(
      find.byKey(const Key('companion_lan_url_field')),
      'https://10.0.0.8:8765/c/ABCDEF',
    );
    await tester.tap(find.byKey(const Key('companion_lan_connect_button')));
    await tester.pumpAndSettle();
    expect(find.text('Conectado · Vender'), findsOneWidget);
    expect(find.byKey(const Key('companion_lan_error')), findsNothing);
  });

  testWidgets('SC-119-02 enlace inválido muestra error', (tester) async {
    final client = CompanionLanClient((_) => _Gateway(null));
    await tester.pumpWidget(
      MaterialApp(home: LanConnectScreen(client: client)),
    );
    await tester.enterText(
      find.byKey(const Key('companion_lan_url_field')),
      'https://10.0.0.8:8765/c/ABCDEF',
    );
    await tester.tap(find.byKey(const Key('companion_lan_connect_button')));
    await tester.pumpAndSettle();
    expect(find.text('Enlace no válido o expirado'), findsOneWidget);
    expect(find.byKey(const Key('companion_lan_status')), findsNothing);
  });

  testWidgets('SC-122-01 leer el QR conecta sin pegar el enlace', (tester) async {
    const link = 'https://10.0.0.8:8765/c/ABCDEF';
    final client = CompanionLanClient(
      (_) => _Gateway(
        Uri.parse(
          'https://10.0.0.8:8765/companion/?storeId=t&mode=VENDER&pairingCode=ABCDEF',
        ),
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: LanConnectScreen(
          client: client,
          ensureCamera: () async => true,
          qrReader: (onCode) => TextButton(
            onPressed: () => onCode(link),
            child: const Text('simular-qr'),
          ),
        ),
      ),
    );
    await tester.tap(find.byKey(const Key('companion_lan_read_qr_button')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('simular-qr'));
    await tester.pumpAndSettle();
    expect(find.text('Conectado · Vender'), findsOneWidget);
  });

  testWidgets('SC-123-01 sin permiso no abre el visor', (tester) async {
    final client = CompanionLanClient((_) => _Gateway(null));
    await tester.pumpWidget(
      MaterialApp(
        home: LanConnectScreen(
          client: client,
          ensureCamera: () async => false,
          openSettings: () async {},
        ),
      ),
    );
    await tester.tap(find.byKey(const Key('companion_lan_read_qr_button')));
    await tester.pumpAndSettle();
    expect(find.text(cameraPermissionMessage), findsOneWidget);
    expect(find.text('Apunte al QR del POS'), findsNothing);
    expect(
      find.byKey(const Key('companion_camera_settings_button')),
      findsOneWidget,
    );
  });

  testWidgets('SC-123-02 con permiso el QR simulado conecta', (tester) async {
    const link = 'https://10.0.0.8:8765/c/ABCDEF';
    final client = CompanionLanClient(
      (_) => _Gateway(
        Uri.parse(
          'https://10.0.0.8:8765/companion/?storeId=t&mode=VENDER&pairingCode=ABCDEF',
        ),
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: LanConnectScreen(
          client: client,
          ensureCamera: () async => true,
          qrReader: (onCode) => TextButton(
            onPressed: () => onCode(link),
            child: const Text('simular-qr'),
          ),
        ),
      ),
    );
    await tester.tap(find.byKey(const Key('companion_lan_read_qr_button')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('simular-qr'));
    await tester.pumpAndSettle();
    expect(find.text('Conectado · Vender'), findsOneWidget);
  });
}
