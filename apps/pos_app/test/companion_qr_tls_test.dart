import 'dart:io';

import 'package:adapters/companion_lan_server.dart';
import 'package:core/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app/config/companion_lan_config.dart';
import 'package:pos_app/di/pos_composition.dart';
import 'package:pos_app/widgets/companion_qr_panel.dart';

void main() {
  setUp(() {
    CompanionLanConfig.lanPortOverrideForTests = 0;
    PosComposition.prepareCompanionQrCallCount = 0;
    CompanionQrPanel.suppressQrImageForTests = false;
    CompanionQrPanel.suppressPhoneStatusForTests = false;
  });
  tearDown(() {
    CompanionLanConfig.lanPortOverrideForTests = null;
    CompanionQrPanel.suppressQrImageForTests = false;
    CompanionQrPanel.suppressPhoneStatusForTests = false;
  });

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
    skip: Platform.isWindows ? null : 'Solo Windows',
  );

  test(
    'SC-126-01 prepareCompanionQr ignora companionAdvertisedHost cacheada',
    () async {
      final priorTls = PosComposition.lanCompanionTls;
      final priorHost = CompanionLanConfig.advertisedHostOverrideForTests;
      final root = await Directory.systemTemp.createTemp('sc126_web_');
      addTearDown(() => root.delete(recursive: true));
      await File(
        '${root.path}${Platform.pathSeparator}index.html',
      ).writeAsString('ok');
      CompanionLanConfig.resolveWebRootOverride = () => root;
      PosComposition.lanCompanionTls = true;
      final composition = PosComposition.memory();
      try {
        await composition.ensureDemoStore();
        CompanionLanConfig.advertisedHostOverrideForTests = '10.0.0.1';
        PosComposition.companionAdvertisedHost = '10.0.0.99';
        final first = await composition.prepareCompanionQr(CompanionMode.vender);
        CompanionLanConfig.advertisedHostOverrideForTests = '10.0.0.2';
        final second = await composition.prepareCompanionQr(CompanionMode.vender);
        expect(first!.launchUrl, contains('10.0.0.1'));
        expect(second!.launchUrl, contains('10.0.0.2'));
      } finally {
        await composition.close();
        PosComposition.lanCompanionTls = priorTls;
        CompanionLanConfig.advertisedHostOverrideForTests = priorHost;
        CompanionLanConfig.resolveWebRootOverride = null;
        PosComposition.companionAdvertisedHost = '';
      }
    },
    skip: Platform.isWindows ? null : 'Solo Windows',
  );

  test(
    'SC-129-01 certIpMismatch si IP del QR distinta al certificado',
    () async {
      final priorTls = PosComposition.lanCompanionTls;
      final priorHost = CompanionLanConfig.advertisedHostOverrideForTests;
      final root = await Directory.systemTemp.createTemp('sc129_web_');
      final dataDir = await Directory.systemTemp.createTemp('sc129_data_');
      addTearDown(() async {
        await root.delete(recursive: true);
        await dataDir.delete(recursive: true);
      });
      await File(
        '${root.path}${Platform.pathSeparator}index.html',
      ).writeAsString('ok');
      CompanionLanConfig.resolveWebRootOverride = () => root;
      CompanionLanConfig.advertisedHostOverrideForTests = '10.165.87.218';
      PosComposition.lanCompanionTls = true;
      final dbPath = '${dataDir.path}${Platform.pathSeparator}pos.db';
      final composition = PosComposition.file(dbPath);
      try {
        await composition.ensureDemoStore();
        await composition.prepareCompanionQr(CompanionMode.vender);
        CompanionLanConfig.advertisedHostOverrideForTests = '10.165.87.116';
        final state = await composition.prepareCompanionQr(CompanionMode.vender);
        expect(state!.certIpMismatch, isTrue);
      } finally {
        await composition.close();
        PosComposition.lanCompanionTls = priorTls;
        CompanionLanConfig.advertisedHostOverrideForTests = priorHost;
        CompanionLanConfig.resolveWebRootOverride = null;
      }
    },
    skip: Platform.isWindows ? null : 'Solo Windows',
  );

  testWidgets('SC-129-01 UI mismatch menciona reiniciar el POS', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CompanionCertIpMismatchHint(
            key: Key('companion_cert_ip_mismatch'),
          ),
        ),
      ),
    );
    expect(
      find.textContaining('Reinicie el POS'),
      findsOneWidget,
    );
  });

  test(
    'SC-130-01 el Future del QR es estable; Actualizar genera código nuevo',
    () async {
      final priorTls = PosComposition.lanCompanionTls;
      final priorHost = CompanionLanConfig.advertisedHostOverrideForTests;
      final root = await Directory.systemTemp.createTemp('sc130_web_');
      addTearDown(() => root.delete(recursive: true));
      await File(
        '${root.path}${Platform.pathSeparator}index.html',
      ).writeAsString('ok');
      CompanionLanConfig.resolveWebRootOverride = () => root;
      CompanionLanConfig.advertisedHostOverrideForTests = '10.165.87.218';
      PosComposition.lanCompanionTls = true;
      final composition = PosComposition.memory();
      try {
        await composition.ensureDemoStore();
        PosComposition.prepareCompanionQrCallCount = 0;
        final future = composition.prepareCompanionQr(CompanionMode.vender);
        expect(PosComposition.prepareCompanionQrCallCount, 1);
        final first = await future;
        final second = await future;
        expect(first!.pairingCode, second!.pairingCode);
        expect(PosComposition.prepareCompanionQrCallCount, 1);
        final third = await composition.prepareCompanionQr(CompanionMode.vender);
        expect(PosComposition.prepareCompanionQrCallCount, 2);
        expect(third!.pairingCode, isNot(first.pairingCode));
      } finally {
        await composition.close();
        PosComposition.lanCompanionTls = priorTls;
        CompanionLanConfig.advertisedHostOverrideForTests = priorHost;
        CompanionLanConfig.resolveWebRootOverride = null;
      }
    },
    skip: Platform.isWindows ? null : 'Solo Windows',
  );

  testWidgets(
    'SC-130-01 el panel no relanza prepareCompanionQr al reconstruir',
    (tester) async {
      CompanionQrPanel.suppressQrImageForTests = true;
      CompanionQrPanel.suppressPhoneStatusForTests = true;
      final composition = PosComposition.memory();
      addTearDown(() async {
        await composition.close();
      });
      final seeded = CompanionQrState(
        launchUrl: 'https://10.165.87.218:8765/c/pair01',
        pairingCode: 'pair01',
        serverRunning: true,
        advertisedHost: '10.165.87.218',
      );
      const panelKey = Key('sc130_panel');
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CompanionQrPanel(
              key: panelKey,
              composition: composition,
              mode: CompanionMode.vender,
              qrKey: const Key('sc130_qr'),
              qrFutureForTests: Future.value(seeded),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('Código: pair01'), findsOneWidget);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CompanionQrPanel(
              key: panelKey,
              composition: composition,
              mode: CompanionMode.vender,
              qrKey: const Key('sc130_qr'),
              qrFutureForTests: Future.value(seeded),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('Código: pair01'), findsOneWidget);
      expect(PosComposition.prepareCompanionQrCallCount, 0);
    },
  );

  testWidgets('SC-127-01 panel muestra companion_advertised_host', (
    tester,
  ) async {
    CompanionQrPanel.suppressQrImageForTests = true;
    CompanionQrPanel.suppressPhoneStatusForTests = true;
    final composition = PosComposition.memory();
    addTearDown(() async {
      await composition.close();
    });
    final seeded = CompanionQrState(
      launchUrl: 'https://10.165.87.218:8765/c/pair01',
      pairingCode: 'pair01',
      serverRunning: true,
      advertisedHost: '10.165.87.218',
      advertisedInterface: 'Ethernet 5',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CompanionQrPanel(
            composition: composition,
            mode: CompanionMode.vender,
            qrKey: const Key('sc127_qr'),
            qrFutureForTests: Future.value(seeded),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.byKey(const Key('companion_advertised_host')), findsOneWidget);
    expect(
      find.textContaining('Red: 10.165.87.218 (Ethernet 5)'),
      findsOneWidget,
    );
  });
}