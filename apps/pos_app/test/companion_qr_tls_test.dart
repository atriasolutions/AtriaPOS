import 'dart:io';

import 'package:adapters/companion_lan_server.dart';
import 'package:core/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app/config/companion_lan_config.dart';
import 'package:pos_app/di/pos_composition.dart';
import 'package:pos_app/widgets/companion_qr_panel.dart';

void main() {
  test(
    'SC-114-04 prepareCompanionQr expone caInstallUrl con TLS',
    () async {
      final priorTls = PosComposition.lanCompanionTls;
      final priorHost = CompanionLanConfig.advertisedHostOverrideForTests;
      final root = await Directory.systemTemp.createTemp('sc114_web_');
      addTearDown(() => root.delete(recursive: true));
      await File(
        '${root.path}${Platform.pathSeparator}index.html',
      ).writeAsString('ok');
      CompanionLanConfig.resolveWebRootOverride = () => root;
      CompanionLanConfig.advertisedHostOverrideForTests = '192.168.42.88';
      PosComposition.lanCompanionTls = true;
      PosComposition.companionAdvertisedHost = '';
      final composition = PosComposition.memory();
      try {
        await composition.ensureDemoStore();
        final state =
            await composition.prepareCompanionQr(CompanionMode.vender);
        expect(state, isNotNull);
        expect(state!.caInstallUrl, isNotNull);
        expect(
          state.caInstallUrl,
          contains(CompanionLanServer.caInstallHelpPath),
        );
        expect(state.caInstallUrl, contains('192.168.42.88'));
        expect(state.launchUrl, isNotNull);
      } finally {
        await composition.close();
        PosComposition.lanCompanionTls = priorTls;
        CompanionLanConfig.advertisedHostOverrideForTests = priorHost;
        CompanionLanConfig.resolveWebRootOverride = null;
      }
    },
    skip: !Platform.isWindows ? 'Solo Windows' : false,
  );

  testWidgets('SC-114-05 CompanionCaInstallHint muestra clave', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CompanionCaInstallHint(
            installUrl: 'https://192.168.42.1:8765/companion/instalar-certificado',
          ),
        ),
      ),
    );
    expect(find.byKey(const Key('companion_ca_install_hint')), findsOneWidget);
    expect(
      find.textContaining('instalar-certificado'),
      findsOneWidget,
    );
  });
}