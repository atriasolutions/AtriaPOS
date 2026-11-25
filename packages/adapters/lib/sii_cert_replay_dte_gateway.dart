import 'dart:convert';
import 'dart:io';

import 'package:core/atria_pos_core.dart';

import 'file_certificate_store.dart';
import 'sii_boleta_builder.dart';

enum SiiReplayScenario {
  success,
  timeout,
  rechazada,
}

/// Emisor DTE Fase A: valida certificado y responde según escenario (sin red).
class SiiCertReplayDteGateway implements DteGateway {
  SiiCertReplayDteGateway({
    required SaleRepository sales,
    required CertificateStore certificates,
    this.scenario = SiiReplayScenario.success,
    this.successFolio = 9001,
    Map<String, String>? fixtureOverrides,
  })  : _sales = sales,
        _validate = ValidateCertificate(certificates),
        _builder = SiiBoletaBuilder(),
        _fixtureOverrides = fixtureOverrides ?? const {};

  final SaleRepository _sales;
  final ValidateCertificate _validate;
  final SiiBoletaBuilder _builder;
  final SiiReplayScenario scenario;
  final int successFolio;
  final Map<String, String> _fixtureOverrides;
  final _emitted = <SaleId, DteEmitResult>{};

  factory SiiCertReplayDteGateway.fromEnvironment({
    required SaleRepository sales,
    CertificateStore? certificates,
  }) {
    const raw = String.fromEnvironment('SII_REPLAY_SCENARIO', defaultValue: 'success');
    final scenario = SiiReplayScenario.values.firstWhere(
      (s) => s.name == raw,
      orElse: () => SiiReplayScenario.success,
    );
    final store = certificates ?? FileCertificateStore.fromEnvironment();
    return SiiCertReplayDteGateway(
      sales: sales,
      certificates: store,
      scenario: scenario,
    );
  }

  @override
  Future<DteEmitResult> emit(DteEmitRequest request) async {
    if (_emitted.containsKey(request.saleId)) {
      return _emitted[request.saleId]!;
    }

    try {
      await _validate(request.storeId);
    } on CertificateNotConfiguredFailure catch (e) {
      return _pendiente(e.message);
    } on CertificateExpiredFailure catch (e) {
      return _pendiente(e.message);
    }

    final sale = await _sales.findById(request.storeId, request.saleId);
    if (sale == null) {
      return _pendiente('Venta no encontrada para emisión DTE');
    }
    _builder.build(sale);

    final fixtureName = _fixtureOverrides[scenario.name] ?? scenario.name;
    final fromFixture = _tryLoadFixture(fixtureName);
    if (fromFixture != null) {
      _emitted[request.saleId] = fromFixture;
      return fromFixture;
    }

    final result = switch (scenario) {
      SiiReplayScenario.success => DteEmitResult(
          status: DteStatus.emitida,
          folio: successFolio,
          pdfUrl: null,
        ),
      SiiReplayScenario.timeout => const DteEmitResult(
          status: DteStatus.pendienteDte,
          errorMessage: 'Timeout SII simulado (replay)',
        ),
      SiiReplayScenario.rechazada => const DteEmitResult(
          status: DteStatus.rechazadaSii,
          errorMessage: 'Rechazo SII simulado (replay)',
        ),
    };
    if (result.status == DteStatus.emitida) {
      _emitted[request.saleId] = result;
    }
    return result;
  }

  @override
  Future<DteEmitResult> emitCreditNote(DteCreditNoteEmitRequest request) async {
    try {
      await _validate(request.storeId);
    } on CertificateNotConfiguredFailure catch (e) {
      return _pendiente(e.message);
    } on CertificateExpiredFailure catch (e) {
      return _pendiente(e.message);
    }

    return switch (scenario) {
      SiiReplayScenario.success => DteEmitResult(
          status: DteStatus.emitida,
          folio: successFolio + 1,
        ),
      SiiReplayScenario.timeout => const DteEmitResult(
          status: DteStatus.pendienteDte,
          errorMessage: 'Timeout replay NC',
        ),
      SiiReplayScenario.rechazada => const DteEmitResult(
          status: DteStatus.rechazadaSii,
          errorMessage: 'Rechazo replay NC',
        ),
    };
  }

  DteEmitResult _pendiente(String message) => DteEmitResult(
        status: DteStatus.pendienteDte,
        errorMessage: message,
      );

  DteEmitResult? _tryLoadFixture(String name) {
    try {
      final file = File('test/fixtures/sii/$name.json');
      if (!file.existsSync()) return null;
      final map = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final status = DteStatus.fromApi(map['status'] as String? ?? 'PENDIENTE_DTE');
      return DteEmitResult(
        status: status,
        folio: map['folio'] as int?,
        errorMessage: map['errorMessage'] as String?,
      );
    } catch (_) {
      return null;
    }
  }
}