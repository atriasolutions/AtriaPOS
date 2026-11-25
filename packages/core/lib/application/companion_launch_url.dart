import '../domain/domain.dart';
import 'resolve_companion_short_link.dart';

/// URL corta del QR (DEC-060, SLICE-107).
String buildCompanionShortLinkUrl({
  required Uri base,
  required String pairingCode,
}) {
  return Uri(
    scheme: base.scheme,
    host: base.host,
    port: base.port,
    path: '${CompanionLanConstants.shortLinkPathPrefix}/$pairingCode',
  ).toString();
}

/// Query de redirección PWA tras `GET /c/{code}`.
Uri buildCompanionPwaRedirectUri(CompanionShortLinkTarget target) {
  return Uri(
    path: '/companion/',
    queryParameters: {
      'storeId': target.storeId,
      'mode': target.mode.apiValue,
      'pairingCode': target.pairingCode,
    },
  );
}