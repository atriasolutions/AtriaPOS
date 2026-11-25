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

  /// Solo para tests (SLICE-113).
  static Directory? Function()? resolveWebRootOverride;

  static Directory? resolveCompanionWebRoot() {
    final override = resolveWebRootOverride;
    if (override != null) return override();
    return selectCompanionWebRoot(
      environmentRoot: webRootFromEnvironment,
      candidates: _rootCandidates(),
      besideExecutable: _resolveBesideExecutable(),
    );
  }

  static bool hasValidCompanionWebBuild() =>
      resolveCompanionWebRoot() != null;

  /// Elige la carpeta de la PWA.
  /// Solo se aceptan carpetas con `index.html` (SC-113-01).
  static Directory? selectCompanionWebRoot({
    required String environmentRoot,
    required Iterable<String> candidates,
    Directory? besideExecutable,
  }) {
    final fromEnv = environmentRoot.trim();
    if (fromEnv.isNotEmpty) {
      final dir = Directory(fromEnv);
      if (_isValidWebBuild(dir)) return dir;
    }
    for (final candidate in candidates) {
      final dir = Directory(candidate);
      if (_isValidWebBuild(dir)) return dir;
    }
    if (besideExecutable != null && _isValidWebBuild(besideExecutable)) {
      return besideExecutable;
    }
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

  /// Solo para tests (SLICE-114).
  static String? advertisedHostOverrideForTests;

  static String resolveAdvertisedHostSync() {
    final testOverride = advertisedHostOverrideForTests;
    if (testOverride != null && testOverride.trim().isNotEmpty) {
      return testOverride.trim();
    }
    final override = advertisedHostOverride.trim();
    if (override.isNotEmpty) return override;
    try {
      final interfaces = _listNetworkInterfacesBlocking();
      return _pickAdvertisedHostFromInterfaces(interfaces);
    } catch (_) {}
    return InternetAddress.loopbackIPv4.address;
  }

  static List<NetworkInterface> _listNetworkInterfacesBlocking() {
    List<NetworkInterface>? result;
    Object? error;
    NetworkInterface.list(
      type: InternetAddressType.IPv4,
      includeLinkLocal: false,
    )
        .then((value) => result = value)
        .catchError((Object e) => error = e);
    final deadline = DateTime.now().add(const Duration(seconds: 3));
    while (result == null && error == null) {
      if (DateTime.now().isAfter(deadline)) break;
      sleep(const Duration(milliseconds: 5));
    }
    if (result != null) return result!;
    if (error != null) throw error!;
    return [];
  }

  static Future<String> resolveAdvertisedHost() async {
    final testOverride = advertisedHostOverrideForTests;
    if (testOverride != null && testOverride.trim().isNotEmpty) {
      return testOverride.trim();
    }
    final override = advertisedHostOverride.trim();
    if (override.isNotEmpty) return override;
    try {
      final interfaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4,
        includeLinkLocal: false,
      );
      return _pickAdvertisedHostFromInterfaces(interfaces);
    } catch (_) {}
    return InternetAddress.loopbackIPv4.address;
  }

  /// Prioriza la mejor IPv4 entre candidatos (SLICE-114).
  static String pickAdvertisedHostIpv4({
    required String hostOverride,
    required Iterable<({String interfaceName, String ipv4})> addresses,
  }) {
    final override = hostOverride.trim();
    if (override.isNotEmpty) return override;
    var bestIp = '';
    var bestScore = -1 << 30;
    for (final entry in addresses) {
      final raw = entry.ipv4;
      if (raw.startsWith('169.254.')) continue;
      final score = companionLanScoreInterface(entry.interfaceName, raw);
      if (score > bestScore) {
        bestScore = score;
        bestIp = raw;
      }
    }
    if (bestIp.isNotEmpty) return bestIp;
    return InternetAddress.loopbackIPv4.address;
  }

  static String _pickAdvertisedHostFromInterfaces(
    List<NetworkInterface> interfaces,
  ) {
    final entries = <({String interfaceName, String ipv4})>[];
    for (final interface in interfaces) {
      for (final addr in interface.addresses) {
        if (addr.isLoopback) continue;
        entries.add((interfaceName: interface.name, ipv4: addr.address));
      }
    }
    return pickAdvertisedHostIpv4(
      hostOverride: '',
      addresses: entries,
    );
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