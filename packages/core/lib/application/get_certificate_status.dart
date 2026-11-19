import '../domain/domain.dart';
import 'auth_helpers.dart';
import 'ports/certificate_store.dart';
import 'ports/session_provider.dart';

class CertificateStatusView {
  const CertificateStatusView({
    required this.status,
    this.subject,
    this.validFrom,
    this.validTo,
  });

  final CertificateStatus status;
  final String? subject;
  final DateTime? validFrom;
  final DateTime? validTo;
}

class GetCertificateStatus {
  GetCertificateStatus(this._store, this._sessions);

  final CertificateStore _store;
  final SessionProvider _sessions;

  Future<CertificateStatusView> call(StoreId storeId) async {
    AuthPolicy.require(
      requireActiveSession(_sessions),
      Permission.anularVenta,
    );

    final info = await _store.loadActiveCertificate(storeId);
    if (info == null) {
      return const CertificateStatusView(
        status: CertificateStatus.noConfigurado,
      );
    }

    final status = _resolveStatus(info);
    return CertificateStatusView(
      status: status,
      subject: info.subject,
      validFrom: info.validFrom,
      validTo: info.validTo,
    );
  }

  CertificateStatus _resolveStatus(CertificateInfo info) {
    final now = DateTime.now().toUtc();
    if (now.isBefore(info.validFrom) || !now.isBefore(info.validTo)) {
      return CertificateStatus.vencido;
    }
    if (info.status == CertificateStatus.vencido) {
      return CertificateStatus.vencido;
    }
    return CertificateStatus.valido;
  }
}