/// Reloj de referencia para eventos operativos (ventas, turno, DTE).
abstract class TrustedClock {
  DateTime now();

  bool get isDegraded;

  TrustedClockSource get source;

  DateTime? get lastSyncAt;

  /// Ajuste respecto al reloj del dispositivo (microsegundos).
  Duration get offset;
}

enum TrustedClockSource { shoa, device }

/// Reloj con offset y flags mutables tras sincronización NTP.
class MutableTrustedClock implements TrustedClock {
  MutableTrustedClock({
    Duration offset = Duration.zero,
    bool isDegraded = true,
    TrustedClockSource source = TrustedClockSource.device,
    DateTime? lastSyncAt,
  })  : _offset = offset,
        _isDegraded = isDegraded,
        _source = source,
        _lastSyncAt = lastSyncAt;

  Duration _offset;
  bool _isDegraded;
  TrustedClockSource _source;
  DateTime? _lastSyncAt;

  @override
  DateTime now() => DateTime.now().toUtc().add(_offset);

  @override
  bool get isDegraded => _isDegraded;

  @override
  TrustedClockSource get source => _source;

  @override
  DateTime? get lastSyncAt => _lastSyncAt;

  @override
  Duration get offset => _offset;

  void updateFromSync({
    required Duration newOffset,
    required TrustedClockSource newSource,
    required DateTime syncedAt,
    bool degraded = false,
  }) {
    _offset = newOffset;
    _source = newSource;
    _lastSyncAt = syncedAt;
    _isDegraded = degraded;
  }
}

/// Reloj fijo para tests.
class FakeTrustedClock implements TrustedClock {
  FakeTrustedClock(this._instant, {this.isDegraded = false, this.source = TrustedClockSource.shoa});

  DateTime _instant;
  @override
  final bool isDegraded;
  @override
  final TrustedClockSource source;
  @override
  DateTime? lastSyncAt;

  @override
  Duration get offset => Duration.zero;

  @override
  DateTime now() => _instant;

  void setInstant(DateTime instant) => _instant = instant.toUtc();
}