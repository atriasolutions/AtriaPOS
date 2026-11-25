import '../domain/domain.dart';
import 'auth_helpers.dart';
import 'ports/scan_session_repository.dart';
import 'ports/session_provider.dart';
import 'record_stock_receipt.dart';

class ConfirmStockReceiptScanResult {
  const ConfirmStockReceiptScanResult({
    required this.session,
    required this.lines,
  });

  final ScanSession session;
  final List<ScanSessionConfirmationLine> lines;
}

class ConfirmStockReceiptScanInput {
  const ConfirmStockReceiptScanInput({
    required this.storeId,
    required this.sessionId,
    this.idempotencyKey,
  });

  final StoreId storeId;
  final ScanSessionId sessionId;
  final String? idempotencyKey;
}

class ConfirmStockReceiptScan {
  ConfirmStockReceiptScan(
    this._sessions,
    this._recordReceipt,
    this._sessionProvider,
  );

  final ScanSessionRepository _sessions;
  final RecordStockReceipt _recordReceipt;
  final SessionProvider _sessionProvider;

  Future<ConfirmStockReceiptScanResult> call(
    ConfirmStockReceiptScanInput input,
  ) async {
    final actor = requireActiveSession(_sessionProvider);
    AuthPolicy.require(actor, Permission.ajustarInventario);

    final session = await _sessions.findById(input.storeId, input.sessionId);
    if (session == null) {
      throw NotFoundFailure(
        'Sesión de escaneo no encontrada',
        details: {'sessionId': input.sessionId},
      );
    }

    if (session.state == ScanSessionState.confirmed) {
      final key = input.idempotencyKey?.trim();
      if (key != null &&
          key.isNotEmpty &&
          session.idempotencyKey == key &&
          session.confirmationLines != null) {
        return ConfirmStockReceiptScanResult(
          session: session,
          lines: session.confirmationLines!,
        );
      }
      throw const ConflictFailure('La sesión de escaneo ya fue confirmada');
    }

    if (session.state == ScanSessionState.cancelled) {
      throw const ValidationFailure(
        'No se puede confirmar una sesión cancelada',
      );
    }

    if (session.kind != ScanSessionKind.receiptScan) {
      throw const ValidationFailure(
        'Solo se puede confirmar ingreso en sesiones receiptScan',
      );
    }

    if (session.lines.isEmpty) {
      throw const ValidationFailure(
        'La sesión no tiene productos escaneados',
      );
    }

    final guideRef = session.guideRef;
    final lotRef = session.lotRef;
    if (guideRef == null || lotRef == null) {
      throw const ValidationFailure(
        'La sesión de ingreso no tiene guía o lote',
      );
    }

    final results = <ScanSessionConfirmationLine>[];
    for (final line in session.lines) {
      final receipt = await _recordReceipt(
        RecordStockReceiptInput(
          storeId: input.storeId,
          productId: line.productId,
          quantity: line.quantity,
          guideRef: guideRef,
          lotRef: lotRef,
        ),
      );
      results.add(
        ScanSessionConfirmationLine(
          productId: receipt.productId,
          quantity: line.quantity,
          stock: receipt.stock,
          movementId: receipt.movementId,
        ),
      );
    }

    final key = input.idempotencyKey?.trim();
    final confirmed = session.copyWith(
      state: ScanSessionState.confirmed,
      idempotencyKey: key?.isEmpty == true ? null : key,
      confirmationLines: results,
    );
    await _sessions.save(confirmed);

    return ConfirmStockReceiptScanResult(session: confirmed, lines: results);
  }
}