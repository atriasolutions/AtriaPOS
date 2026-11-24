import '../../domain/domain.dart';

abstract class CollaboratorRepository {
  Future<Collaborator?> findById(StoreId storeId, CollaboratorId id);

  Future<Collaborator?> findActiveBySellerCode(
    StoreId storeId,
    String sellerCode,
  );

  Future<List<Collaborator>> listByStore(StoreId storeId);

  Future<void> save(Collaborator collaborator);
}