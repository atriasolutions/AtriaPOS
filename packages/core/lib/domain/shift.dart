import 'failures.dart';
import 'shift_id.dart';
import 'store_id.dart';

enum ShiftStatus { abierto, cerrado }

class Shift {
  Shift({
    required this.id,
    required this.storeId,
    required this.openingCashClp,
    required this.openedAt,
    required this.status,
    this.closedAt,
    this.countedCashClp,
  });

  final ShiftId id;
  final StoreId storeId;
  final int openingCashClp;
  final DateTime openedAt;
  final ShiftStatus status;
  final DateTime? closedAt;
  final int? countedCashClp;

  bool get isOpen => status == ShiftStatus.abierto;

  static Shift open({
    required StoreId storeId,
    required int openingCashClp,
    DateTime? openedAt,
  }) {
    if (openingCashClp < 0) {
      throw const ValidationFailure(
        'El fondo inicial no puede ser negativo',
      );
    }
    return Shift(
      id: newShiftId(),
      storeId: storeId,
      openingCashClp: openingCashClp,
      openedAt: openedAt ?? DateTime.now().toUtc(),
      status: ShiftStatus.abierto,
    );
  }

  Shift close({required int countedCashClp, DateTime? closedAt}) {
    if (!isOpen) {
      throw const ValidationFailure('El turno ya está cerrado');
    }
    if (countedCashClp < 0) {
      throw const ValidationFailure('El efectivo contado no puede ser negativo');
    }
    return Shift(
      id: id,
      storeId: storeId,
      openingCashClp: openingCashClp,
      openedAt: openedAt,
      status: ShiftStatus.cerrado,
      closedAt: closedAt ?? DateTime.now().toUtc(),
      countedCashClp: countedCashClp,
    );
  }
}