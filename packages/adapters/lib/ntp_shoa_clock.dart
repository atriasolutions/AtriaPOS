import 'package:core/application/ports/trusted_clock.dart';
import 'package:ntp/ntp.dart';

import 'drift_clock_state_repository.dart';

const _shoaHost = 'ntp.shoa.cl';
const _shoaIp = '200.54.149.19';

class NtpShoaTrustedClock implements TrustedClock {
  NtpShoaTrustedClock(this._inner, this._persist);

  final MutableTrustedClock _inner;
  final DriftClockStateRepository _persist;

  @override
  DateTime now() => _inner.now();

  @override
  bool get isDegraded => _inner.isDegraded;

  @override
  TrustedClockSource get source => _inner.source;

  @override
  DateTime? get lastSyncAt => _inner.lastSyncAt;

  @override
  Duration get offset => _inner.offset;

  void hydrateFromSnapshot(ClockStateSnapshot snapshot) {
    _inner.updateFromSync(
      newOffset: snapshot.offset,
      newSource: snapshot.source,
      syncedAt: snapshot.lastSyncAt ?? DateTime.now().toUtc(),
      degraded: snapshot.isDegraded,
    );
  }

  Future<void> loadPersisted() async {
    final snapshot = await _persist.load();
    if (snapshot != null) {
      hydrateFromSnapshot(snapshot);
    }
  }

  Future<void> syncFromNetwork({
    Duration timeout = const Duration(seconds: 5),
  }) async {
    final deviceBefore = DateTime.now().toUtc();
    DateTime ntpUtc;
    try {
      ntpUtc = await NTP.now(
        lookUpAddress: _shoaHost,
        timeout: timeout,
      ).timeout(timeout);
    } catch (_) {
      try {
        ntpUtc = await NTP.now(
          lookUpAddress: _shoaIp,
          timeout: timeout,
        ).timeout(timeout);
      } catch (_) {
        _inner.updateFromSync(
          newOffset: _inner.offset,
          newSource: TrustedClockSource.device,
          syncedAt: deviceBefore,
          degraded: true,
        );
        await _persist.save(
          ClockStateSnapshot(
            offset: _inner.offset,
            source: _inner.source,
            isDegraded: true,
            lastSyncAt: deviceBefore,
          ),
        );
        return;
      }
    }
    final deviceAfter = DateTime.now().toUtc();
    final deviceMid = deviceBefore.add(
      Duration(
        microseconds: deviceAfter
                .difference(deviceBefore)
                .inMicroseconds ~/
            2,
      ),
    );
    final offset = ntpUtc.toUtc().difference(deviceMid);
    final syncedAt = deviceAfter;
    _inner.updateFromSync(
      newOffset: offset,
      newSource: TrustedClockSource.shoa,
      syncedAt: syncedAt,
      degraded: false,
    );
    await _persist.save(
      ClockStateSnapshot(
        offset: offset,
        source: TrustedClockSource.shoa,
        isDegraded: false,
        lastSyncAt: syncedAt,
      ),
    );
  }
}