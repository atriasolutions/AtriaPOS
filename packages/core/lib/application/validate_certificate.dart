import '../domain/domain.dart';
import 'ports/certificate_store.dart';

class ValidateCertificate {
  ValidateCertificate(this._store);

  final CertificateStore _store;

  Future<CertificateInfo> call(StoreId storeId) async {
    final info = await _store.loadActiveCertificate(storeId);
    if (info == null || info.status == CertificateStatus.noConfigurado) {
      throw const CertificateNotConfiguredFailure(
        'No hay certificado configurado para emitir boleta.',
      );
    }
    if (!info.isValid || info.status == CertificateStatus.vencido) {
      throw const CertificateExpiredFailure(
        'El certificado digital está vencido o no es válido.',
      );
    }
    return info;
  }
}