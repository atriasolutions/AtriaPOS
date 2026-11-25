import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:core/api/api.dart';
import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Servidor HTTP/WebSocket embebido para companion LAN (SLICE-97–98).
class CompanionLanServer {
  CompanionLanServer({
    required this.companionService,
    this.host = '0.0.0.0',
    this.port = CompanionLanConstants.defaultPort,
    this.staticRoot,
    this.securityContext,
    this.caPem,
  });

  final CompanionService companionService;
  final String host;
  final int port;
  final Directory? staticRoot;
  final SecurityContext? securityContext;
  final String? caPem;

  /// Ruta pública de la CA para instalación en el celular (DEC-059).
  static const caDownloadPath = '/companion/atria-ca.pem';

  static const caInstallHelpPath = '/companion/instalar-certificado';

  bool get usesTls => securityContext != null;

  HttpServer? _httpServer;
  final StreamController<String> _scans = StreamController<String>.broadcast();

  /// Lecturas decodeadas listas para [ScannerIngress] POS.
  Stream<String> get scans => _scans.stream;

  int? get boundPort => _httpServer?.port;

  bool get isRunning => _httpServer != null;

  Uri get baseUri {
    final p = boundPort ?? port;
    return Uri(
      scheme: usesTls ? 'https' : 'http',
      host: '127.0.0.1',
      port: p,
    );
  }

  Future<void> start() async {
    if (_httpServer != null) return;
    final router = Router();
    router.get('/health', _health);
    router.get(
      '${CompanionLanConstants.shortLinkPathPrefix}/<pairingCode>',
      _shortLinkRedirect,
    );
    router.post(
      '/v0/stores/<storeId>/companion/pair',
      _pair,
    );
    router.get(CompanionLanConstants.wsPath, _wsUpgrade);
    router.get(caDownloadPath, _serveCaPem);
    router.get(caInstallHelpPath, _serveCaInstallHelp);
    router.get('/companion', _companionIndex);
    router.get('/companion/', _companionIndex);
    router.get('/companion/<path|.*>', _companionStatic);

    final handler = Pipeline()
        .addMiddleware(_corsMiddleware)
        .addHandler(router.call);
    _httpServer = await shelf_io.serve(
      handler,
      host,
      port,
      securityContext: securityContext,
    );
  }

  Future<void> stop() async {
    await _httpServer?.close(force: true);
    _httpServer = null;
  }

  void dispose() {
    unawaited(stop());
    unawaited(_scans.close());
  }

  late final ResolveCompanionShortLink _shortLink =
      ResolveCompanionShortLink(companionService.repository);

  Future<Response> _shortLinkRedirect(
    Request request,
    String pairingCode,
  ) async {
    final target = await _shortLink(pairingCode);
    if (target == null) {
      return Response(
        404,
        body: 'Enlace no válido o expirado',
        headers: {'content-type': 'text/plain; charset=utf-8'},
      );
    }
    final location = buildCompanionPwaRedirectUri(target).toString();
    return Response.found(location);
  }

  Response _health(Request request) {
    return Response.ok(
      jsonEncode({'ok': true, 'service': 'companion-lan'}),
      headers: _jsonHeaders,
    );
  }

  Future<Response> _pair(Request request, String storeId) async {
    try {
      final body = await request.readAsString();
      final map = jsonDecode(body);
      if (map is! Map<String, dynamic>) {
        return _jsonError('JSON inválido', 400);
      }
      final pairingCode = map['pairingCode'];
      final mode = map['mode'];
      if (pairingCode is! String || mode is! String) {
        return _jsonError('pairingCode y mode son obligatorios', 400);
      }
      final result = await companionService.pair(
        storeId,
        CompanionPairRequest(pairingCode: pairingCode, mode: mode),
      );
      return switch (result) {
        ApiSuccess(:final data, :final statusCode) => Response(
            statusCode,
            body: jsonEncode({
              'token': data.token,
              'expiresAt': data.expiresAt,
              'wsPath': data.wsPath,
              'mode': data.mode,
            }),
            headers: _jsonHeaders,
          ),
        ApiFailure(:final error, :final statusCode) => Response(
            statusCode,
            body: jsonEncode({'code': error.code, 'message': error.message}),
            headers: _jsonHeaders,
          ),
      };
    } catch (_) {
      return _jsonError('Solicitud inválida', 400);
    }
  }

  FutureOr<Response> _wsUpgrade(Request request) {
    final token = request.url.queryParameters['token'];
    if (token == null || token.isEmpty) {
      return Response(400, body: 'token requerido');
    }
    return webSocketHandler(
      (WebSocketChannel channel) => _onWebSocket(channel, token),
    )(request);
  }

  void _onWebSocket(WebSocketChannel channel, String token) {
    channel.stream.listen(
      (dynamic raw) async {
        if (raw is! String) return;
        final message = CompanionWsMessage.decode(raw);
        if (message == null) return;
        if (CompanionWsMessage.isHeartbeat(message)) {
          channel.sink.add(jsonEncode({'type': 'heartbeat', 'ok': true}));
          return;
        }
        final code = CompanionWsMessage.scanCode(message);
        if (code == null) return;
        final scan = await companionService.submitScanFromToken(token, code);
        if (scan == null) return;
        _scans.add(scan.code);
        channel.sink.add(jsonEncode({'type': 'scan', 'accepted': true}));
      },
      onError: (_) {},
      cancelOnError: true,
    );
  }

  Response _serveCaPem(Request request) {
    final pem = caPem;
    if (pem == null || pem.isEmpty) {
      return Response.notFound('CA no configurada');
    }
    return Response.ok(
      pem,
      headers: {
        'content-type': 'application/x-pem-file; charset=utf-8',
        'content-disposition': 'attachment; filename="atria-ca.pem"',
      },
    );
  }

  Response _serveCaInstallHelp(Request request) {
    final body =
        '<!DOCTYPE html><html lang="es"><head><meta charset="utf-8">'
        '<title>Instalar certificado Atria</title></head><body>'
        '<h1>Certificado del POS (una sola vez)</h1>'
        '<ol>'
        '<li><a href="$caDownloadPath">Descargar atria-ca.pem</a></li>'
        '<li>Android: Ajustes → Seguridad → Instalar certificado → CA</li>'
        '<li>Vuelva a escanear el QR del POS</li>'
        '</ol></body></html>';
    return Response.ok(
      body,
      headers: {'content-type': 'text/html; charset=utf-8'},
    );
  }

  Future<Response> _companionIndex(Request request) {
    return _serveStatic('index.html');
  }

  Future<Response> _companionStatic(Request request, String path) async {
    final cleaned = path.isEmpty ? 'index.html' : path;
    return _serveStatic(cleaned);
  }

  Future<Response> _serveStatic(String relativePath) async {
    final root = staticRoot;
    if (root == null) {
      return Response.ok(
        '<!DOCTYPE html><html><body>Companion Atria POS</body></html>',
        headers: {'content-type': 'text/html; charset=utf-8'},
      );
    }
    final file = File('${root.path}${Platform.pathSeparator}$relativePath');
    if (!await file.exists()) {
      return Response.notFound('No encontrado');
    }
    final bytes = await file.readAsBytes();
  final mime = _mimeForPath(relativePath);
    return Response.ok(bytes, headers: {'content-type': mime});
  }

  Response _jsonError(String message, int status) {
    return Response(
      status,
      body: jsonEncode({
        'code': 'VALIDACION',
        'message': message,
      }),
      headers: _jsonHeaders,
    );
  }

  static const _jsonHeaders = {'content-type': 'application/json; charset=utf-8'};

  static Middleware _corsMiddleware = (Handler inner) {
    return (Request request) async {
      if (request.method == 'OPTIONS') {
        return Response.ok('', headers: _corsHeaders);
      }
      final response = await inner(request);
      return response.change(headers: _corsHeaders);
    };
  };

  static const _corsHeaders = {
    'access-control-allow-origin': '*',
    'access-control-allow-methods': 'GET, POST, OPTIONS',
    'access-control-allow-headers': 'Content-Type',
  };

  static String _mimeForPath(String path) {
    if (path.endsWith('.js')) return 'application/javascript';
    if (path.endsWith('.css')) return 'text/css';
    if (path.endsWith('.json')) return 'application/json';
    if (path.endsWith('.png')) return 'image/png';
    if (path.endsWith('.wasm')) return 'application/wasm';
    return 'text/html; charset=utf-8';
  }
}