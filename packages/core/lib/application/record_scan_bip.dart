import '../domain/domain.dart';
import 'auth_helpers.dart';
import 'ports/scan_session_repository.dart';
import 'ports/session_provider.dart';
import 'resolve_scan_code.dart';

class RecordScanBipInput {
  const RecordScanBipInput({
    required this.storeId,
    required this.sessionId,
    required this.code,
    this.now,
  });

  final StoreId storeId;
  final ScanSessionId sessionId;
  final String code;
  final DateTime? now;
}

class RecordScanBip {
  RecordScanBip(
    this._sessions,
    this._resolve,
    this._sessionProvider,
  );

  final ScanSessionRepository _sessions;
  final ResolveScanCode _resolve;
  final SessionProvider _sessionProvider;

  Future<ScanSession> call(RecordScanBipInput input) async {
    final session = requireActiveSession(_sessionProvider);
    AuthPolicy.require(session, Permission.ajustarInventario);

    final scan = await _sessions.findById(input.storeId, input.sessionId);
    if (scan == null) {
      throw NotFoundFailure(
        'Sesión de escaneo no encontrada',
        details: {'sessionId': input.sessionId},
      );
    }
    if (!scan.isDraft) {
      throw const ValidationFailure(
        'La sesión de escaneo ya no admite nuevos códigos',
      );
    }

    final now = input.now ?? DateTime.now().toUtc();
    final normalized = input.code.trim();

    if (scan.lastBipCode == normalized &&
        scan.lastBipAt != null &&
        now.difference(scan.lastBipAt!) < ScanSession.debounceWindow) {
      return scan;
    }

    final target = await _resolve(input.storeId, normalized);

    final existing = scan.lineFor(target.productId);
    final nextQty = (existing?.quantity ?? 0) + 1;
    final line = ScanSessionLine(
      productId: target.productId,
      productName: target.productName,
      quantity: nextQty,
      lastScannedAt: now,
    );

    final updated = scan
        .withLine(line)
        .copyWith(lastBipCode: normalized, lastBipAt: now);

    await _sessions.save(updated);
    return updated;
  }
}