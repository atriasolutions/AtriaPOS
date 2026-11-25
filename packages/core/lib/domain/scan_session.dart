import 'failures.dart';
import 'product_id.dart';
import 'scan_session_id.dart';
import 'scan_session_kind.dart';
import 'inventory_close_id.dart';
import 'scan_session_confirmation_line.dart';
import 'scan_session_inventory_confirmation_line.dart';
import 'shift_id.dart';
import 'scan_session_line.dart';
import 'scan_session_state.dart';
import 'store_id.dart';

class ScanSession {
  const ScanSession({
    required this.id,
    required this.storeId,
    required this.kind,
    required this.state,
    required this.lines,
    required this.createdAt,
    required this.createdByUserId,
    this.guideRef,
    this.lotRef,
    this.lastBipCode,
    this.lastBipAt,
    this.idempotencyKey,
    this.confirmationLines,
    this.inventoryCloseId,
    this.inventoryCloseShiftId,
    this.inventoryClosedAt,
    this.inventoryConfirmationLines,
  });

  final ScanSessionId id;
  final StoreId storeId;
  final ScanSessionKind kind;
  final ScanSessionState state;
  final String? guideRef;
  final String? lotRef;
  final List<ScanSessionLine> lines;
  final DateTime createdAt;
  final String createdByUserId;
  final String? lastBipCode;
  final DateTime? lastBipAt;
  final String? idempotencyKey;
  final List<ScanSessionConfirmationLine>? confirmationLines;
  final InventoryCloseId? inventoryCloseId;
  final ShiftId? inventoryCloseShiftId;
  final DateTime? inventoryClosedAt;
  final List<ScanSessionInventoryConfirmationLine>? inventoryConfirmationLines;

  static const int maxDistinctLines = 500;

  static const Duration debounceWindow = Duration(milliseconds: 400);

  bool get isDraft => state == ScanSessionState.draft;

  ScanSessionLine? lineFor(ProductId productId) {
    for (final line in lines) {
      if (line.productId == productId) return line;
    }
    return null;
  }

  ScanSession withLine(ScanSessionLine line) {
    final updated = <ScanSessionLine>[];
    var replaced = false;
    for (final existing in lines) {
      if (existing.productId == line.productId) {
        updated.add(line);
        replaced = true;
      } else {
        updated.add(existing);
      }
    }
    if (!replaced) {
      if (lines.length >= maxDistinctLines) {
        throw const ValidationFailure(
          'La sesión supera el máximo de líneas permitidas',
        );
      }
      updated.add(line);
    }
    return copyWith(lines: updated);
  }

  ScanSession copyWith({
    ScanSessionState? state,
    List<ScanSessionLine>? lines,
    String? lastBipCode,
    DateTime? lastBipAt,
    String? idempotencyKey,
    List<ScanSessionConfirmationLine>? confirmationLines,
    InventoryCloseId? inventoryCloseId,
    ShiftId? inventoryCloseShiftId,
    DateTime? inventoryClosedAt,
    List<ScanSessionInventoryConfirmationLine>? inventoryConfirmationLines,
  }) {
    return ScanSession(
      id: id,
      storeId: storeId,
      kind: kind,
      state: state ?? this.state,
      guideRef: guideRef,
      lotRef: lotRef,
      lines: lines ?? this.lines,
      createdAt: createdAt,
      createdByUserId: createdByUserId,
      lastBipCode: lastBipCode,
      lastBipAt: lastBipAt,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      confirmationLines: confirmationLines ?? this.confirmationLines,
      inventoryCloseId: inventoryCloseId ?? this.inventoryCloseId,
      inventoryCloseShiftId:
          inventoryCloseShiftId ?? this.inventoryCloseShiftId,
      inventoryClosedAt: inventoryClosedAt ?? this.inventoryClosedAt,
      inventoryConfirmationLines:
          inventoryConfirmationLines ?? this.inventoryConfirmationLines,
    );
  }
}