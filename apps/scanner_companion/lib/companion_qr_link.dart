/// Enlace corto del QR del POS (`https://{host}:{port}/c/{codigo}`).
class CompanionQrLink {
  const CompanionQrLink({
    required this.host,
    required this.port,
    required this.pairingCode,
    required this.tls,
  });

  final String host;
  final int port;
  final String pairingCode;
  final bool tls;

  Uri get base => Uri(
        scheme: tls ? 'https' : 'http',
        host: host,
        port: port,
      );

  Uri get shortUri => base.replace(
        path: '/c/$pairingCode',
      );
}

/// Devuelve null si el texto no es un enlace `/c/{codigo}`.
CompanionQrLink? parseCompanionQrLink(String raw) {
  final uri = Uri.tryParse(raw.trim());
  if (uri == null) return null;
  if (uri.scheme != 'https' && uri.scheme != 'http') return null;
  if (uri.host.isEmpty) return null;
  final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
  if (segments.length != 2 || segments.first != 'c') return null;
  final code = segments[1];
  if (code.isEmpty) return null;
  final port = uri.hasPort ? uri.port : (uri.scheme == 'https' ? 443 : 80);
  return CompanionQrLink(
    host: uri.host,
    port: port,
    pairingCode: code,
    tls: uri.scheme == 'https',
  );
}
