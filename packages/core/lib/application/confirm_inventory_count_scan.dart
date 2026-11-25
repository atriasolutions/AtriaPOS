import '../domain/domain.dart';
import 'auth_helpers.dart';
import 'close_inventory.dart';
import 'ports/scan_session_repository.dart';
import 'ports/session_provider.dart';

class ConfirmInventoryCountScanResult {
  const ConfirmInventoryCountScanResult({
    required this.session,
    required this.close,
    required this.lines,
  });

  final ScanSession session;
  final InventoryClose close;
  final List<ScanSessionInventoryConfirmationLine> lines;
}

class ConfirmInventoryCountScanInput {
  const ConfirmInventoryCountScanInput({
    required this.storeId,
    required this.sessionId,
    this.idempotencyKey,
  });

  final StoreId storeId;
  final ScanSessionId sessionId;
  final String? idempotencyKey;
}

class ConfirmInventoryCountScan {
  ConfirmInventoryCountScan(
    this._sessions,
    this._closeInventory,
    this._sessionProvider,
  );

  final ScanSessionRepository _sessions;
  final CloseInventory _closeInventory;
  final SessionProvider _sessionProvider;

  Future<ConfirmInventoryCountScanResult> call(
    ConfirmInventoryCountScanInput input,
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

    final key = input.idempotencyKey?.trim();

    if (session.state == ScanSessionState.confirmed) {
      if (key != null &&
          key.isNotEmpty &&
          session.idempotencyKey == key &&
          session.inventoryCloseId != null &&
          session.inventoryConfirmationLines != null &&
          session.inventoryCloseShiftId != null &&
          session.inventoryClosedAt != null) {
        final close = InventoryClose(
          id: session.inventoryCloseId!,
          storeId: session.storeId,
          shiftId: session.inventoryCloseShiftId!,
          createdAt: session.inventoryClosedAt!,
          actorUserId: session.createdByUserId,
          lines: [
            for (final line in session.inventoryConfirmationLines!)
              InventoryCloseLine(
                id: 'replay',
                productId: line.productId,
                systemStock: line.systemStock,
                countedStock: line.countedStock,
                variance: line.variance,
                unitsSoldInShift: line.unitsSoldInShift,
              ),
          ],
        );
        return ConfirmInventoryCountScanResult(
          session: session,
          close: close,
          lines: session.inventoryConfirmationLines!,
        );
      }
      throw const ConflictFailure('La sesión de escaneo ya fue confirmada');
    }

    if (session.state == ScanSessionState.cancelled) {
      throw const ValidationFailure(
        'No se puede confirmar una sesión cancelada',
      );
    }

    if (session.kind != ScanSessionKind.countScan) {
      throw const ValidationFailure(
        'Solo se puede confirmar conteo en sesiones countScan',
      );
    }

    if (session.lines.isEmpty) {
      throw const ValidationFailure(
        'La sesión no tiene productos escaneados',
      );
    }

    final inputs = [
      for (final line in session.lines)
        CloseInventoryLineInput(
          productId: line.productId,
          countedQty: line.quantity,
        ),
    ];

    final close = await _closeInventory(input.storeId, inputs);

    final snapshot = [
      for (final line in close.lines)
        ScanSessionInventoryConfirmationLine(
          productId: line.productId,
          systemStock: line.systemStock,
          countedStock: line.countedStock,
          variance: line.variance,
          unitsSoldInShift: line.unitsSoldInShift,
        ),
    ];

    final confirmed = session.copyWith(
      state: ScanSessionState.confirmed,
      idempotencyKey: key?.isEmpty == true ? null : key,
      inventoryCloseId: close.id,
      inventoryCloseShiftId: close.shiftId,
      inventoryClosedAt: close.createdAt,
      inventoryConfirmationLines: snapshot,
    );
    await _sessions.save(confirmed);

    return ConfirmInventoryCountScanResult(
      session: confirmed,
      close: close,
      lines: snapshot,
    );
  }
}