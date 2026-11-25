import 'dart:convert';
import 'dart:io';

import 'package:core/api/api.dart';
import 'package:core/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:pos_app/config/store_config.dart';
import 'package:pos_app/di/pos_composition.dart';

import 'support/companion_lan_flow_helpers.dart';

final _windowsOnly = !Platform.isWindows ? 'Solo Windows (LAN default)' : false;

void main() {
  setUpAll(() {
    PosComposition.lanCompanionTls = false;
    PosComposition.companionAdvertisedHost = '127.0.0.1';
  });

  test('SC-112-01 vender scan llega a búsqueda de producto', () async {
    final composition = PosComposition.memory();
    try {
      if (composition.companionLanServer == null) return;
      await composition.ensureDemoStore();
      await seedSupervisorSession(composition);
      const barcode = 'EAN11201';
      final created = await composition.productService.createProduct(
        kDemoStoreId,
        const CreateProductRequest(
          name: 'Prod 112-01',
          salePriceClp: 990,
          initialStock: 5,
          barcode: barcode,
        ),
      );
      expect(created, isA<ApiSuccess<ProductResponse>>());

      final result = await simulateVenderOnLanScan(
        composition,
        CompanionMode.vender,
        barcode,
      );
      expect(result, isA<ApiSuccess<SearchProductsResponse>>());
      final items = (result as ApiSuccess<SearchProductsResponse>).data.items;
      expect(items, isNotEmpty);
      expect(items.any((p) => p.name == 'Prod 112-01'), isTrue);
    } finally {
      await composition.close();
    }
  }, skip: _windowsOnly);

  test('SC-112-02 ingreso scan registra línea en sesión', () async {
    final composition = PosComposition.memory();
    try {
      if (composition.companionLanServer == null) return;
      await composition.ensureDemoStore();
      await seedSupervisorSession(composition);
      const barcode = 'EAN11202';
      await composition.productService.createProduct(
        kDemoStoreId,
        const CreateProductRequest(
          name: 'Prod 112-02',
          salePriceClp: 500,
          initialStock: 0,
          barcode: barcode,
        ),
      );
      final session = await composition.scanSessionService.createScanSession(
        kDemoStoreId,
        const CreateScanSessionRequest(
          kind: 'receiptScan',
          guideRef: 'G-112',
          lotRef: 'L-112',
        ),
      );
      final sessionId = (session as ApiSuccess<ScanSessionResponse>).data.sessionId;

      final recorded = await simulateRecordScanOnLanScan(
        composition,
        CompanionMode.receiptScan,
        sessionId,
        barcode,
      );
      expect(recorded, isA<ApiSuccess<ScanSessionResponse>>());
      final lines = (recorded as ApiSuccess<ScanSessionResponse>).data.lines;
      expect(lines, isNotEmpty);
      expect(lines.first.quantity, greaterThanOrEqualTo(1));
    } finally {
      await composition.close();
    }
  }, skip: _windowsOnly);

  test('SC-112-03 conteo scan registra línea en sesión', () async {
    final composition = PosComposition.memory();
    try {
      if (composition.companionLanServer == null) return;
      await composition.ensureDemoStore();
      await seedShiftOpen(composition);
      const barcode = 'EAN11203';
      await composition.productService.createProduct(
        kDemoStoreId,
        const CreateProductRequest(
          name: 'Prod 112-03',
          salePriceClp: 800,
          initialStock: 12,
          barcode: barcode,
        ),
      );
      final session = await composition.scanSessionService.createScanSession(
        kDemoStoreId,
        const CreateScanSessionRequest(kind: 'countScan'),
      );
      final sessionId = (session as ApiSuccess<ScanSessionResponse>).data.sessionId;

      final recorded = await simulateRecordScanOnLanScan(
        composition,
        CompanionMode.countScan,
        sessionId,
        barcode,
      );
      expect(recorded, isA<ApiSuccess<ScanSessionResponse>>());
      final lines = (recorded as ApiSuccess<ScanSessionResponse>).data.lines;
      expect(lines, isNotEmpty);
      expect(lines.first.productName, 'Prod 112-03');
    } finally {
      await composition.close();
    }
  }, skip: _windowsOnly);

  test('SC-112-04 enlace corto QR hasta redirect PWA', () async {
    final composition = PosComposition.memory();
    try {
      final server = composition.companionLanServer;
      if (server == null) return;
      await composition.ensureDemoStore();
      final state = await composition.prepareCompanionQr(CompanionMode.vender);
      expect(state, isNotNull);

      final uri = server.baseUri.replace(
        path: '${CompanionLanConstants.shortLinkPathPrefix}/${state!.pairingCode}',
      );
      final request = http.Request('GET', uri)..followRedirects = false;
      final streamed = await http.Client().send(request);
      final res = await http.Response.fromStream(streamed);
      expect(res.statusCode, 302);
      final location = res.headers['location'];
      expect(location, contains('/companion/'));
      expect(location, contains('pairingCode=${state.pairingCode}'));
      expect(location, contains('mode=VENDER'));
    } finally {
      await composition.close();
    }
  }, skip: _windowsOnly);
}