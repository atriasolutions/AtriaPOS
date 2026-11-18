import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

import 'sii_transport.dart';

/// Cliente HTTP hacia ambiente certificación SII.
class HttpSiiTransport implements SiiTransport {
  HttpSiiTransport({
    http.Client? client,
    String? baseUrl,
    Duration? timeout,
  })  : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? _defaultBaseUrl(),
        _timeout = timeout ?? const Duration(seconds: 30);

  final http.Client _client;
  final String _baseUrl;
  final Duration _timeout;

  static String _defaultBaseUrl() {
    const ambiente = String.fromEnvironment('SII_AMBIENTE', defaultValue: 'cert');
    if (ambiente == 'prod') {
      return 'https://palena.sii.cl/cgi_dte/UPL/DTEUpload';
    }
    return 'https://maullin.sii.cl/cgi_dte/UPL/DTEUpload';
  }

  @override
  Future<SiiTransportResponse> sendSignedDte(
    String signedXml, {
    required int tipoDte,
    required int folio,
  }) async {
    try {
      final uri = Uri.parse(_baseUrl);
      final response = await _client
          .post(
            uri,
            headers: {
              HttpHeaders.contentTypeHeader: 'application/xml',
            },
            body: signedXml,
          )
          .timeout(_timeout);

      if (response.statusCode >= 500 || response.statusCode == 408) {
        return const SiiTransportResponse(
          outcome: SiiTransportOutcome.timeout,
          rejectionDetail: 'Error de red o tiempo de espera SII',
        );
      }
      return _parseResponse(response.body, response.statusCode);
    } on SocketException {
      return const SiiTransportResponse(
        outcome: SiiTransportOutcome.timeout,
        rejectionDetail: 'Sin conexión al SII',
      );
    } on HttpException {
      return const SiiTransportResponse(
        outcome: SiiTransportOutcome.timeout,
        rejectionDetail: 'Error HTTP SII',
      );
    } catch (e) {
      return SiiTransportResponse(
        outcome: SiiTransportOutcome.timeout,
        rejectionDetail: e.toString(),
      );
    }
  }

  SiiTransportResponse _parseResponse(String body, int statusCode) {
    if (body.contains('RECHAZADO') || body.contains('Error')) {
      return SiiTransportResponse(
        outcome: SiiTransportOutcome.rechazada,
        rejectionDetail: body.length > 200 ? body.substring(0, 200) : body,
      );
    }
    if (statusCode >= 200 && statusCode < 300) {
      var trackId = 'HTTP-$statusCode';
      try {
        final doc = XmlDocument.parse(body);
        final id = doc.findAllElements('TRACKID').firstOrNull;
        if (id != null) trackId = id.innerText;
      } catch (_) {
        if (body.contains('TRACKID')) {
          trackId = 'PARSED';
        }
      }
      return SiiTransportResponse(
        outcome: SiiTransportOutcome.emitida,
        trackId: trackId,
      );
    }
    return SiiTransportResponse(
      outcome: SiiTransportOutcome.rechazada,
      rejectionDetail: 'HTTP $statusCode',
    );
  }

  void close() => _client.close();
}