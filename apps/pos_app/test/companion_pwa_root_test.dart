import 'dart:io';

import 'package:core/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app/config/companion_lan_config.dart';
import 'package:pos_app/di/pos_composition.dart';
import 'package:pos_app/widgets/companion_qr_panel.dart';

void main() {
  test(
    'SC-113-04 sin PWA bloquea prepareCompanionQr',
    () async {
      final priorTls = PosComposition.lanCompanionTls;
      CompanionLanConfig.resolveWebRootOverride = () => null;
      PosComposition.lanCompanionTls = true;
      final composition = PosComposition.memory();
      try {
        await composition.ensureDemoStore();
        final state =
            await composition.prepareCompanionQr(CompanionMode.vender);
        expect(state, isNotNull);
        expect(state!.blockedReason, CompanionQrBlockedReason.pwaMissing);
        expect(state.launchUrl, isNull);
        expect(state.pairingCode, isNull);
      } finally {
        await composition.close();
        PosComposition.lanCompanionTls = priorTls;
        CompanionLanConfig.resolveWebRootOverride = null;
      }
    },
    skip: !Platform.isWindows ? 'Solo Windows' : false,
  );

  testWidgets('SC-113-04 panel muestra companion_pwa_missing', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: CompanionPwaMissingInstructions()),
      ),
    );
    expect(find.byKey(const Key('companion_pwa_missing')), findsOneWidget);
    expect(find.textContaining('prepare-companion-pwa.ps1'), findsOneWidget);
  });
}