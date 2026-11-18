import 'package:core/pos_barrio_core.dart';

import 'folio_allocator.dart';
import 'sii_dte_signer.dart';
import 'sii_dte_xml_builder.dart';
import 'sii_emisor_config.dart';
import 'sii_transport.dart';

/// Emisor DTE Fase B: certificado, folio CAF, XML firmado y red SII.
class SiiLiveDteGateway implements DteGateway {
  SiiLiveDteGateway({
    required SaleRepository sales,
    required CertificateStore certificates,
    required FolioAllocator folios,
    required SiiTransport transport,
    SiiEmisorConfig? emisor,
    SiiDteXmlBuilder? xmlBuilder,
    SiiDteSigner? signer,
    String? certPath,
    String? certPassword,
  })  : _sales = sales,
        _validate = ValidateCertificate(certificates),
        _folios = folios,
        _transport = transport,
        _emisor = emisor ?? SiiEmisorConfig.fromEnvironment(),
        _xmlBuilder = xmlBuilder ?? SiiDteXmlBuilder(),
        _signer = signer ?? const SiiDteSigner(),
        _certPath = certPath ?? _certPathFromEnvironment(),
        _certPassword = certPassword ?? SiiDteSigner.passwordFromEnvironment(),
        _emitted = {};

  final SaleRepository _sales;
  final ValidateCertificate _validate;
  final FolioAllocator _folios;
  final SiiTransport _transport;
  final SiiEmisorConfig _emisor;
  final SiiDteXmlBuilder _xmlBuilder;
  final SiiDteSigner _signer;
  final String? _certPath;
  final String? _certPassword;
  final Map<SaleId, DteEmitResult> _emitted;

  static String? _certPathFromEnvironment() {
    const path = String.fromEnvironment('SII_CERT_PATH');
    return path.isEmpty ? null : path;
  }

  @override
  Future<DteEmitResult> emit(DteEmitRequest request) async {
    if (_emitted.containsKey(request.saleId)) {
      return _emitted[request.saleId]!;
    }

    final existing = await _sales.findById(request.storeId, request.saleId);
    if (existing != null && existing.dteStatus == DteStatus.emitida) {
      final cached = DteEmitResult(
        status: DteStatus.emitida,
        folio: existing.folio,
        pdfUrl: existing.pdfUrl,
      );
      _emitted[request.saleId] = cached;
      return cached;
    }

    try {
      await _validate(request.storeId);
    } on CertificateNotConfiguredFailure catch (e) {
      return _pendiente(e.message);
    } on CertificateExpiredFailure catch (e) {
      return _pendiente(e.message);
    }

    if (!_emisor.isConfigured) {
      return _pendiente(
        'Configure SII_RUT_EMISOR para emisión live (puente piloto)',
      );
    }

    final sale = existing ??
        await _sales.findById(request.storeId, request.saleId);
    if (sale == null) {
      return _pendiente('Venta no encontrada para emisión DTE');
    }

    int folio;
    try {
      folio = await _folios.allocateNext(request.storeId, request.documentType);
    } on FolioAgotadoException catch (e) {
      return _pendiente(e.message);
    }

    final documentXml = _xmlBuilder.buildDocumento(
      sale: sale,
      folio: folio,
      emisor: _emisor,
    );
    final signed = _signer.signXml(
      documentXml,
      certPath: _certPath,
      password: _certPassword,
    );

    final response = await _transport.sendSignedDte(
      signed,
      tipoDte: request.documentType,
      folio: folio,
    );

    final result = switch (response.outcome) {
      SiiTransportOutcome.emitida => DteEmitResult(
          status: DteStatus.emitida,
          folio: folio,
          pdfUrl: response.trackId,
        ),
      SiiTransportOutcome.rechazada => DteEmitResult(
          status: DteStatus.rechazadaSii,
          errorMessage: response.rejectionDetail ?? 'Rechazo SII',
        ),
      SiiTransportOutcome.timeout => DteEmitResult(
          status: DteStatus.pendienteDte,
          errorMessage: response.rejectionDetail ?? 'Timeout SII',
        ),
    };

    if (result.status == DteStatus.emitida) {
      _emitted[request.saleId] = result;
    }
    return result;
  }

  DteEmitResult _pendiente(String message) => DteEmitResult(
        status: DteStatus.pendienteDte,
        errorMessage: message,
      );
}