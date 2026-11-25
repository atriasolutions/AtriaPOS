import '../domain/domain.dart';
import 'auth_helpers.dart';
import 'emit_credit_note_dte.dart';
import 'ports/credit_note_repository.dart';
import 'ports/dte_gateway.dart';
import 'ports/dte_queue_repository.dart';
import 'ports/product_repository.dart';
import 'ports/sale_repository.dart';
import 'ports/session_provider.dart';
import 'ports/shift_repository.dart';
import 'ports/stock_movement_repository.dart';
import 'ports/trusted_clock.dart';

class IssueCreditNoteLineInput {
  const IssueCreditNoteLineInput({
    required this.productId,
    required this.quantity,
  });

  final ProductId productId;
  final int quantity;
}

class IssueCreditNoteInput {
  const IssueCreditNoteInput({
    required this.storeId,
    required this.saleId,
    this.lines = const [],
  });

  final StoreId storeId;
  final SaleId saleId;
  final List<IssueCreditNoteLineInput> lines;
}

class IssueCreditNoteReturnedLine {
  const IssueCreditNoteReturnedLine({
    required this.productId,
    required this.quantity,
    required this.stockAfter,
  });

  final ProductId productId;
  final int quantity;
  final int stockAfter;
}

class IssueCreditNoteResult {
  const IssueCreditNoteResult({
    required this.creditNote,
    required this.sale,
    required this.returnedLines,
  });

  final CreditNote creditNote;
  final Sale sale;
  final List<IssueCreditNoteReturnedLine> returnedLines;
}

class IssueCreditNote {
  IssueCreditNote(
    this._sales,
    this._products,
    this._movements,
    this._shifts,
    this._creditNotes,
    this._dte,
    this._dteQueue,
    this._sessions, [
    TrustedClock? clock,
  ]) : _clock = clock ?? MutableTrustedClock();

  final SaleRepository _sales;
  final ProductRepository _products;
  final StockMovementRepository _movements;
  final ShiftRepository _shifts;
  final CreditNoteRepository _creditNotes;
  final DteGateway _dte;
  final DteQueueRepository _dteQueue;
  final SessionProvider _sessions;
  final TrustedClock _clock;

  Future<IssueCreditNoteResult> call(IssueCreditNoteInput input) async {
    final session = requireActiveSession(_sessions);
    AuthPolicy.require(session, Permission.anularVenta);
    final actorId = session.userId;

    final sale = await _sales.findById(input.storeId, input.saleId);
    if (sale == null) {
      throw NotFoundFailure(
        'Venta no encontrada',
        details: {'saleId': input.saleId},
      );
    }
    if (sale.isAnulada) {
      throw const ConflictFailure('La venta ya está anulada');
    }
    if (sale.dteStatus != DteStatus.emitida) {
      throw const ValidationFailure(
        'La nota de crédito solo aplica a ventas con boleta emitida. '
        'Use anulación de venta.',
      );
    }
    if (sale.folio == null) {
      throw const ValidationFailure(
        'La venta no tiene folio de boleta para referenciar la NC',
      );
    }

    final openShift = await _shifts.findOpenByStore(input.storeId);
    if (openShift == null) {
      throw const TurnClosedFailure(
        'No hay turno abierto. No se puede emitir nota de crédito.',
      );
    }
    if (sale.shiftId != openShift.id) {
      throw const ValidationFailure(
        'Solo se pueden acreditar ventas del turno abierto actual',
      );
    }

    final soldByProduct = <String, _SoldAgg>{};
    for (final line in sale.lines) {
      final agg = soldByProduct[line.productId];
      if (agg == null) {
        soldByProduct[line.productId] = _SoldAgg(
          productId: line.productId,
          productName: line.productName,
          quantity: line.quantity,
          unitPriceClp: line.unitPriceClp,
        );
      } else {
        if (agg.unitPriceClp != line.unitPriceClp) {
          throw const ValidationFailure(
            'La venta tiene el mismo producto con precios distintos',
          );
        }
        agg.quantity += line.quantity;
      }
    }

    final requested = <String, int>{};
    if (input.lines.isEmpty) {
      for (final agg in soldByProduct.values) {
        final credited = await _creditNotes.sumCreditedQty(
          input.storeId,
          input.saleId,
          agg.productId,
          onlyEmitida: false,
        );
        final remaining = agg.quantity - credited;
        if (remaining > 0) {
          requested[agg.productId] = remaining;
        }
      }
    } else {
      for (final line in input.lines) {
        if (line.quantity <= 0) {
          throw const ValidationFailure(
            'Las cantidades deben ser mayores a cero',
          );
        }
        requested[line.productId] =
            (requested[line.productId] ?? 0) + line.quantity;
      }
    }

    if (requested.isEmpty) {
      throw const ConflictFailure(
        'No quedan unidades por acreditar en esta venta',
      );
    }

    final creditLines = <CreditNoteLine>[];
    var totalClp = 0;
    for (final entry in requested.entries) {
      final sold = soldByProduct[entry.key];
      if (sold == null) {
        throw NotFoundFailure(
          'El producto no figura en la venta',
          details: {'productId': entry.key},
        );
      }
      final credited = await _creditNotes.sumCreditedQty(
        input.storeId,
        input.saleId,
        entry.key,
        onlyEmitida: false,
      );
      final available = sold.quantity - credited;
      if (entry.value > available) {
        if (available <= 0) {
          throw const ConflictFailure(
            'No quedan unidades disponibles para nota de crédito',
          );
        }
        throw ValidationFailure(
          'Cantidad supera lo acreditable ($available)',
        );
      }
      creditLines.add(
        CreditNoteLine(
          productId: sold.productId,
          productName: sold.productName,
          quantity: entry.value,
          unitPriceClp: sold.unitPriceClp,
        ),
      );
      totalClp += entry.value * sold.unitPriceClp;
    }

    final createdAt = _clock.now().toUtc();
    var draft = CreditNote(
      id: newCreditNoteId(),
      storeId: input.storeId,
      saleId: sale.id,
      lines: creditLines,
      totalClp: totalClp,
      dteStatus: DteStatus.pendienteDte,
      createdAt: createdAt,
      actorUserId: actorId,
      referencedSaleFolio: sale.folio!,
      referencedDocumentType: CreditNote.defaultReferencedDocType(),
    );

    draft = await emitCreditNoteDte(draft, sale, _dte, _dteQueue, _clock);

    final returnedLines = <IssueCreditNoteReturnedLine>[];
    for (final line in creditLines) {
      final product = await _products.findById(input.storeId, line.productId);
      if (product == null) {
        throw NotFoundFailure(
          'Producto no encontrado',
          details: {'productId': line.productId},
        );
      }
      final updated = product.applyStockDelta(line.quantity);
      await _products.save(updated);
      await _movements.save(
        StockMovement.record(
          storeId: input.storeId,
          productId: line.productId,
          delta: line.quantity,
          reason: StockAdjustmentReason.notaCredito,
          note: 'NC ${draft.id} venta ${sale.id}',
          actorId: actorId,
          createdAt: createdAt,
        ),
      );
      returnedLines.add(
        IssueCreditNoteReturnedLine(
          productId: line.productId,
          quantity: line.quantity,
          stockAfter: updated.stock,
        ),
      );
    }

    await _creditNotes.save(draft);

    var updatedSale = sale;
    var fullyCredited = true;
    for (final agg in soldByProduct.values) {
      final credited = await _creditNotes.sumCreditedQty(
        input.storeId,
        input.saleId,
        agg.productId,
        onlyEmitida: false,
      );
      if (credited < agg.quantity) {
        fullyCredited = false;
        break;
      }
    }
    if (fullyCredited) {
      updatedSale = sale.markAnulada(
        voidedAt: createdAt,
        voidedByUserId: actorId,
      );
      await _sales.save(updatedSale);
    }

    return IssueCreditNoteResult(
      creditNote: draft,
      sale: updatedSale,
      returnedLines: returnedLines,
    );
  }
}

class _SoldAgg {
  _SoldAgg({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPriceClp,
  });

  final ProductId productId;
  final String productName;
  int quantity;
  final int unitPriceClp;
}