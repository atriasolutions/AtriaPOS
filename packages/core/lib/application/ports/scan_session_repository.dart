import '../../domain/domain.dart';

abstract class ScanSessionRepository {
  Future<void> save(ScanSession session);

  Future<ScanSession?> findById(StoreId storeId, ScanSessionId sessionId);
}