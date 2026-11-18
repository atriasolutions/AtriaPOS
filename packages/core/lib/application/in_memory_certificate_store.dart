import '../domain/domain.dart';
import 'ports/certificate_store.dart';

class InMemoryCertificateStore implements CertificateStore {
  CertificateInfo? info;

  @override
  Future<CertificateInfo?> loadActiveCertificate(StoreId storeId) async => info;
}