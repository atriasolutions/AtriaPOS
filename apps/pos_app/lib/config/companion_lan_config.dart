import 'dart:io';

/// Rutas y red para piloto companion en smartphone (LAN).
abstract final class CompanionLanConfig {
  /// Carpeta `companion_web/build/web` (--dart-define=COMPANION_WEB_ROOT).
  static const webRootFromEnvironment = String.fromEnvironment(
    'COMPANION_WEB_ROOT',
    defaultValue: '',
  );

  /// IP mostrada en el QR (--dart-define=COMPANION_LAN_HOST).
  static const advertisedHostOverride = String.fromEnvironment(
    'COMPANION_LAN_HOST',
    defaultValue: '',
  );

  /// Puerto TCP (--dart-define=COMPANION_LAN_PORT; default 8765 DEC-059).
  static const lanPort = int.fromEnvironment(
    'COMPANION_LAN_PORT',
    defaultValue: 8765,
  );

  /// Bind del socket (default escucha en todas las interfaces).
  static const bindHost = String.fromEnvironment(
    'COMPANION_LAN_BIND',
    defaultValue: '0.0.0.0',
  );

  static Directory? resolveCompanionWebRoot() {
    final fromEnv = webRootFromEnvironment.trim();
    if (fromEnv.isNotEmpty) {
      final dir = Directory(fromEnv);
      if (dir.existsSync()) return dir;
    }
    for (final candidate in _rootCandidates()) {
      final dir = Directory(candidate);
      if (_isValidWebBuild(dir)) return dir;
    }
    final fromExe = _resolveBesideExecutable();
    if (fromExe != null) return fromExe;
    return null;
  }

  static bool _isValidWebBuild(Directory dir) {
    if (!dir.existsSync()) return false;
    return File('${dir.path}${Platform.pathSeparator}index.html').existsSync();
  }

  static Directory? _resolveBesideExecutable() {
    try {
      var dir = File(Platform.resolvedExecutable).parent;
      for (var i = 0; i < 10; i++) {
        final web = Directory(
          '${dir.path}${Platform.pathSeparator}apps${Platform.pathSeparator}companion_web${Platform.pathSeparator}build${Platform.pathSeparator}web',
        );
        if (_isValidWebBuild(web)) return web;
        final web2 = Directory(
          '${dir.path}${Platform.pathSeparator}companion_web${Platform.pathSeparator}build${Platform.pathSeparator}web',
        );
        if (_isValidWebBuild(web2)) return web2;
        dir = dir.parent;
      }
    } catch (_) {}
    return null;
  }

  static Iterable<String> _rootCandidates() {
    final cwd = Directory.current.path;
    final sep = Platform.pathSeparator;
    return [
      '$cwd${sep}apps${sep}companion_web${sep}build${sep}web',
      '$cwd${sep}companion_web${sep}build${sep}web',
    ];
  }

  static Future<String> resolveAdvertisedHost() async {
    final override = advertisedHostOverride.trim();
    if (override.isNotEmpty) return override;
    try {
      final interfaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4,
        includeLinkLocal: false,
      );
      var bestIp = '';
      var bestScore = -1 << 30;
      for (final interface in interfaces) {
        for (final addr in interface.addresses) {
          if (addr.isLoopback) continue;
          final raw = addr.address;
          if (raw.startsWith('169.254.')) continue;
          final score = companionLanScoreInterface(interface.name, raw);
          if (score > bestScore) {
            bestScore = score;
            bestIp = raw;
          }
        }
      }
      if (bestIp.isNotEmpty) return bestIp;
    } catch (_) {}
    return InternetAddress.loopbackIPv4.address;
  }

  /// Prioriza USB tether (RNDIS) y redes 192.168.42.x típicas de Android.
  static int companionLanScoreInterface(String interfaceName, String ipv4) {
    final name = interfaceName.toLowerCase();
    var score = 0;
    if (name.contains('rndis') ||
        name.contains('remote ndis') ||
        name.contains('android') ||
        name.contains('usb ethernet')) {
      score += 120;
    }
    if (ipv4.startsWith('192.168.42.') ||
        ipv4.startsWith('192.168.43.') ||
        ipv4.startsWith('192.168.57.')) {
      score += 90;
    } else if (ipv4.startsWith('192.168.')) {
      score += 50;
    } else if (ipv4.startsWith('10.')) {
      score += 15;
    }
    if (name.contains('vmware') ||
        name.contains('virtual') ||
        name.contains('hyper-v') ||
        name.contains('vethernet') ||
        name.contains('bluetooth') ||
        name.contains('miniport')) {
      score -= 100;
    }
    return score;
  }
}