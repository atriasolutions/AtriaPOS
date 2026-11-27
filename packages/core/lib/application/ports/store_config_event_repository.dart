import '../../domain/domain.dart';

class StoreConfigEvent {
  const StoreConfigEvent({
    required this.id,
    required this.storeId,
    required this.actorUserId,
    required this.occurredAt,
    required this.summary,
  });

  final String id;
  final StoreId storeId;
  final String actorUserId;
  final DateTime occurredAt;
  final String summary;
}

abstract class StoreConfigEventRepository {
  Future<void> append(StoreConfigEvent event);

  Future<List<StoreConfigEvent>> listByStore(StoreId storeId, {int limit = 50});
}