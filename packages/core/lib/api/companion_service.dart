import '../application/application.dart';
import '../domain/domain.dart';
import 'api_error.dart';
import 'api_result.dart';
import 'companion_dtos.dart';

class CompanionService {
  factory CompanionService({
    CompanionPairingRepository? repository,
    TrustedClock? clock,
    CompanionLiveSessions? liveSessions,
  }) {
    final repo = repository ?? InMemoryCompanionPairingRepository();
    final live = liveSessions ?? const NoopCompanionLiveSessions();
    return CompanionService._(
      CreateCompanionPairingOffer(repo, clock),
      PairCompanion(repo, clock),
      CompanionSubmitScan(repo, clock),
      GetCompanionLanStatus(repo, live),
      DisconnectCompanionLan(repo, live),
      repo,
    );
  }

  CompanionService._(
    this._createOffer,
    this._pair,
    this._submitScan,
    this._getLanStatus,
    this._disconnectLan,
    this._repo,
  );

  final CreateCompanionPairingOffer _createOffer;
  final PairCompanion _pair;
  final CompanionSubmitScan _submitScan;
  final GetCompanionLanStatus _getLanStatus;
  final DisconnectCompanionLan _disconnectLan;
  final CompanionPairingRepository _repo;

  Future<ApiResult<CreateCompanionPairingOfferResponse>> createPairingOffer(
    StoreId storeId,
    CompanionMode mode,
  ) async {
    try {
      final result = await _createOffer(
        CreateCompanionPairingOfferInput(storeId: storeId, mode: mode),
      );
      return ApiSuccess(
        CreateCompanionPairingOfferResponse(
          pairingCode: result.pairingCode,
          mode: result.mode.apiValue,
          expiresAt: result.expiresAt.toIso8601String(),
        ),
        statusCode: 200,
      );
    } on ValidationFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 400,
      );
    }
  }

  Future<ApiResult<CompanionPairResponse>> pair(
    StoreId storeId,
    CompanionPairRequest request,
  ) async {
    try {
      final mode = CompanionMode.fromApi(request.mode);
      final result = await _pair(
        PairCompanionInput(
          storeId: storeId,
          pairingCode: request.pairingCode,
          mode: mode,
        ),
      );
      return ApiSuccess(
        CompanionPairResponse(
          token: result.token,
          expiresAt: result.expiresAt.toIso8601String(),
          wsPath: result.wsPath,
          mode: result.mode.apiValue,
        ),
        statusCode: 200,
      );
    } on ValidationFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 400,
      );
    } on ArgumentError {
      return ApiFailure(
        const ApiErrorBody(
          code: 'VALIDACION',
          message: 'Modo companion inválido',
        ),
        statusCode: 400,
      );
    }
  }

  Future<CompanionSubmitScanResult?> submitScanFromToken(
    String token,
    String rawCode,
  ) async {
    try {
      return await _submitScan(
        CompanionSubmitScanInput(token: token, rawCode: rawCode),
      );
    } on ValidationFailure {
      return null;
    }
  }

  Future<CompanionLanStatus> getLanStatus(StoreId storeId) =>
      _getLanStatus(storeId);

  Future<void> disconnectLan(StoreId storeId) => _disconnectLan(storeId);

  CompanionPairingRepository get repository => _repo;
}