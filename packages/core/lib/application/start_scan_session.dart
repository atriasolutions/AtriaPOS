import '../domain/domain.dart';
import 'auth_helpers.dart';
import 'ports/scan_session_repository.dart';
import 'ports/session_provider.dart';

class StartScanSessionInput {
  const StartScanSessionInput({
    required this.storeId,
    required this.kind,
    this.guideRef,
    this.lotRef,
  });

  final StoreId storeId;
  final ScanSessionKind kind;
  final String? guideRef;
  final String? lotRef;
}

class StartScanSession {
  StartScanSession(this._sessions, this._sessionProvider);

  final ScanSessionRepository _sessions;
  final SessionProvider _sessionProvider;

  Future<ScanSession> call(StartScanSessionInput input) async {
    final session = requireActiveSession(_sessionProvider);
    AuthPolicy.require(session, Permission.ajustarInventario);

    String? guideRef;
    String? lotRef;
    if (input.kind == ScanSessionKind.receiptScan) {
      guideRef = StockReceiptRefPolicy.normalize(input.guideRef ?? '');
      lotRef = StockReceiptRefPolicy.normalize(input.lotRef ?? '');
    }

    final now = DateTime.now().toUtc();
    final scan = ScanSession(
      id: newScanSessionId(),
      storeId: input.storeId,
      kind: input.kind,
      state: ScanSessionState.draft,
      guideRef: guideRef,
      lotRef: lotRef,
      lines: const [],
      createdAt: now,
      createdByUserId: session.userId,
    );

    await _sessions.save(scan);
    return scan;
  }
}