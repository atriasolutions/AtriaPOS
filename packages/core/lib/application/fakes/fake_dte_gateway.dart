import '../../domain/domain.dart';
import '../ports/dte_gateway.dart';

enum FakeDteMode {
  alwaysSuccess,
  alwaysFailure,
  failOnceThenSuccess,
  rechazadaSii,
}

class FakeDteGateway implements DteGateway {
  FakeDteGateway({
    this.mode = FakeDteMode.alwaysSuccess,
    this.startingFolio = 1000,
  });

  final FakeDteMode mode;
  final int startingFolio;

  final _resultsBySale = <SaleId, DteEmitResult>{};
  final _resultsByCreditNote = <String, DteEmitResult>{};
  final _failedOnce = <SaleId>{};
  final _failedOnceCreditNote = <String>{};
  late int _folio = startingFolio;
  late int _folioNc = 5000;

  @override
  Future<DteEmitResult> emit(DteEmitRequest request) async {
    if (_resultsBySale.containsKey(request.saleId)) {
      return _resultsBySale[request.saleId]!;
    }

    late final DteEmitResult result;
    if (mode == FakeDteMode.failOnceThenSuccess &&
        !_failedOnce.contains(request.saleId)) {
      _failedOnce.add(request.saleId);
      result = const DteEmitResult(
        status: DteStatus.pendienteDte,
        errorMessage: 'Timeout SII simulado',
      );
    } else if (mode == FakeDteMode.alwaysFailure) {
      result = const DteEmitResult(
        status: DteStatus.pendienteDte,
        errorMessage: 'Servicio no disponible',
      );
    } else if (mode == FakeDteMode.rechazadaSii) {
      result = const DteEmitResult(
        status: DteStatus.rechazadaSii,
        errorMessage: 'Rechazo simulado SII',
      );
    } else {
      _folio++;
      result = DteEmitResult(
        status: DteStatus.emitida,
        folio: _folio,
        pdfUrl: null,
      );
    }

    if (result.status == DteStatus.emitida) {
      _resultsBySale[request.saleId] = result;
    }
    return result;
  }

  @override
  Future<DteEmitResult> emitCreditNote(DteCreditNoteEmitRequest request) async {
    if (_resultsByCreditNote.containsKey(request.creditNoteId)) {
      return _resultsByCreditNote[request.creditNoteId]!;
    }

    late final DteEmitResult result;
    if (mode == FakeDteMode.failOnceThenSuccess &&
        !_failedOnceCreditNote.contains(request.creditNoteId)) {
      _failedOnceCreditNote.add(request.creditNoteId);
      result = const DteEmitResult(
        status: DteStatus.pendienteDte,
        errorMessage: 'Timeout SII simulado NC',
      );
    } else if (mode == FakeDteMode.alwaysFailure) {
      result = const DteEmitResult(
        status: DteStatus.pendienteDte,
        errorMessage: 'Servicio no disponible NC',
      );
    } else if (mode == FakeDteMode.rechazadaSii) {
      result = const DteEmitResult(
        status: DteStatus.rechazadaSii,
        errorMessage: 'Rechazo simulado SII NC',
      );
    } else {
      _folioNc++;
      result = DteEmitResult(
        status: DteStatus.emitida,
        folio: _folioNc,
        pdfUrl: null,
      );
    }

    if (result.status == DteStatus.emitida) {
      _resultsByCreditNote[request.creditNoteId] = result;
    }
    return result;
  }
}