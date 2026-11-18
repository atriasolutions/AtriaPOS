import '../../domain/domain.dart';

abstract class CertificateStore {
  Future<CertificateInfo?> loadActiveCertificate(StoreId storeId);
}