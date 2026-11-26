import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scanner_companion/companion_camera_view.dart';
import 'package:scanner_companion/companion_lan_client.dart';
import 'package:scanner_companion/companion_ui_strings.dart';
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

Widget Function(void Function(String code) onCode) _idleCamera() {
  return (_) => const SizedBox(key: Key('companion_lan_idle_camera'));
}

CompanionLanClient _venderClient() {
  return CompanionLanClient(
    (_) => _Gateway(
      Uri.parse(
        'https://10.0.0.8:8765/companion/?storeId=t&mode=VENDER&pairingCode=ABCDEF',
      ),
    ),
  );
}

Future<void> _pasteLink(
  WidgetTester tester,
  String url,
) async {
  await tester.tap(find.text(companionMoreOptionsTitle));
  await tester.pumpAndSettle();
  await tester.enterText(
    find.byKey(const Key('companion_lan_url_field')),
    url,
  );
}

void main() {
  testWidgets('SC-134-01 iconos en pantalla de empareje', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: LanConnectScreen(client: _venderClient())),
    );
    expect(find.byKey(const Key('companion_lan_read_qr_button')), findsOneWidget);
    expect(find.byIcon(Icons.qr_code_scanner), findsOneWidget);
    expect(find.byKey(const Key('companion_lan_more_options')), findsOneWidget);
    expect(find.byIcon(Icons.link), findsOneWidget);
  });

  testWidgets('SC-136-01 enlace oculto hasta Más opciones', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: LanConnectScreen(client: _venderClient())),
    );
    expect(find.byKey(const Key('companion_lan_url_field')), findsNothing);
    await tester.tap(find.text(companionMoreOptionsTitle));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('companion_lan_url_field')), findsOneWidget);
    expect(find.byKey(const Key('companion_lan_connect_button')), findsOneWidget);
  });

  testWidgets('SC-133-01 copy de caja en pantalla principal', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: LanConnectScreen(client: _venderClient())),
    );
    expect(find.text(companionConnectTitle), findsOneWidget);
    expect(find.text(companionConnectIntro), findsOneWidget);
    expect(find.text(companionReadBoxCodeButtonLabel), findsOneWidget);
    expect(find.byKey(const Key('companion_lan_url_field')), findsNothing);
    expect(find.textContaining('POS'), findsNothing);
    expect(find.textContaining('QR'), findsNothing);
  });

  testWidgets('SC-119-01 conectar muestra el modo Vender', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LanConnectScreen(
          client: _venderClient(),
          scanCamera: _idleCamera(),
        ),
      ),
    );
    await _pasteLink(tester, 'https://10.0.0.8:8765/c/ABCDEF');
    await tester.tap(find.byKey(const Key('companion_lan_connect_button')));
    await tester.pumpAndSettle();
    expect(find.text('Vender'), findsOneWidget);
    expect(find.byKey(const Key('companion_lan_send_scan_button')), findsOneWidget);
    expect(find.byKey(const Key('companion_lan_error')), findsNothing);
  });

  testWidgets('SC-119-02 enlace inválido muestra error', (tester) async {
    final client = CompanionLanClient((_) => _Gateway(null));
    await tester.pumpWidget(
      MaterialApp(home: LanConnectScreen(client: client)),
    );
    await _pasteLink(tester, 'https://10.0.0.8:8765/c/ABCDEF');
    await tester.tap(find.byKey(const Key('companion_lan_connect_button')));
    await tester.pumpAndSettle();
    expect(find.text(companionLinkRejectedMessage), findsOneWidget);
    expect(find.byKey(const Key('companion_lan_status')), findsNothing);
    expect(find.byKey(const Key('companion_lan_send_scan_button')), findsNothing);
  });

  testWidgets('SC-122-01 leer el QR conecta sin pegar el enlace', (tester) async {
    const link = 'https://10.0.0.8:8765/c/ABCDEF';
    await tester.pumpWidget(
      MaterialApp(
        home: LanConnectScreen(
          client: _venderClient(),
          ensureCamera: () async => true,
          scanCamera: _idleCamera(),
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
    expect(find.byKey(const Key('companion_lan_send_scan_button')), findsOneWidget);
    expect(find.text('Vender'), findsOneWidget);
  });

  testWidgets('SC-125-01 doble lectura del QR no saca Conectar del stack', (
    tester,
  ) async {
    const link = 'https://10.0.0.8:8765/c/ABCDEF';
    await tester.pumpWidget(
      MaterialApp(
        home: LanConnectScreen(
          client: _venderClient(),
          ensureCamera: () async => true,
          scanCamera: _idleCamera(),
          qrReader: (onCode) => TextButton(
            onPressed: () {
              onCode(link);
              onCode(link);
            },
            child: const Text('simular-qr-doble'),
          ),
        ),
      ),
    );
    await tester.tap(find.byKey(const Key('companion_lan_read_qr_button')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('simular-qr-doble'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('companion_lan_send_scan_button')), findsOneWidget);
    expect(find.byType(MaterialApp), findsOneWidget);
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
    expect(find.text(companionScanBoxCodeTitle), findsNothing);
    expect(
      find.byKey(const Key('companion_camera_settings_button')),
      findsOneWidget,
    );
  });

  testWidgets('SC-123-02 con permiso el QR simulado conecta', (tester) async {
    const link = 'https://10.0.0.8:8765/c/ABCDEF';
    await tester.pumpWidget(
      MaterialApp(
        home: LanConnectScreen(
          client: _venderClient(),
          ensureCamera: () async => true,
          scanCamera: _idleCamera(),
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
    expect(find.byKey(const Key('companion_lan_send_scan_button')), findsOneWidget);
  });

  testWidgets(
    'SC-132-01 conectar abre trabajo y oculta el formulario',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LanConnectScreen(
            client: _venderClient(),
            scanCamera: _idleCamera(),
          ),
        ),
      );
      await _pasteLink(tester, 'https://10.0.0.8:8765/c/ABCDEF');
      await tester.tap(find.byKey(const Key('companion_lan_connect_button')));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('companion_lan_send_scan_button')),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.ancestor(
            of: find.byKey(const Key('companion_lan_send_scan_button')),
            matching: find.byType(Scaffold),
          ),
          matching: find.byKey(const Key('companion_lan_url_field')),
        ),
        findsNothing,
      );
    },
  );

  testWidgets('SC-132-02 Salir de la caja vuelve al empareje', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LanConnectScreen(
          client: _venderClient(),
          scanCamera: _idleCamera(),
        ),
      ),
    );
    await _pasteLink(tester, 'https://10.0.0.8:8765/c/ABCDEF');
    await tester.tap(find.byKey(const Key('companion_lan_connect_button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('companion_lan_disconnect_button')));
    await tester.pumpAndSettle();
    expect(find.text(companionConnectTitle), findsOneWidget);
    expect(find.byKey(const Key('companion_lan_url_field')), findsNothing);
    expect(find.byKey(const Key('companion_lan_more_options')), findsOneWidget);
    expect(
      find.byKey(const Key('companion_lan_send_scan_button')),
      findsNothing,
    );
  });
}