import '../application/application.dart';
import '../domain/domain.dart';
import 'api_error.dart';
import 'api_result.dart';
import 'fiscal_dtos.dart';

class FiscalService {
  factory FiscalService({
    CertificateStore? certificateStore,
    SessionProvider? sessionProvider,
  }) {
    final certs = certificateStore ?? InMemoryCertificateStore();
    final sessions = sessionProvider ?? InMemorySessionProvider();
    return FiscalService._(
      GetCertificateStatus(certs, sessions),
    );
  }

  FiscalService._(this._getCertificate);

  final GetCertificateStatus _getCertificate;

  Future<ApiResult<CertificateStatusResponse>> getCertificate(
    StoreId storeId,
  ) async {
    try {
      final view = await _getCertificate(storeId);
      return ApiSuccess(
        CertificateStatusResponse(
          status: view.status.apiValue,
          subject: view.subject,
          validFrom: view.validFrom?.toUtc().toIso8601String(),
          validTo: view.validTo?.toUtc().toIso8601String(),
        ),
        statusCode: 200,
      );
    } on ForbiddenFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 403,
      );
    } on CredentialFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 401,
      );
    }
  }
}