import '../domain/domain.dart';
import 'ports/collaborator_repository.dart';

class InMemoryCollaboratorRepository implements CollaboratorRepository {
  final _byId = <String, Collaborator>{};

  @override
  Future<Collaborator?> findById(StoreId storeId, CollaboratorId id) async {
    final c = _byId[id];
    if (c == null || c.storeId != storeId) return null;
    return c;
  }

  @override
  Future<Collaborator?> findActiveBySellerCode(
    StoreId storeId,
    String sellerCode,
  ) async {
    final code = sellerCode.trim().toUpperCase();
    for (final c in _byId.values) {
      if (c.storeId == storeId && c.active && c.sellerCode == code) {
        return c;
      }
    }
    return null;
  }

  @override
  Future<List<Collaborator>> listByStore(StoreId storeId) async {
    return _byId.values
        .where((c) => c.storeId == storeId)
        .toList()
      ..sort((a, b) => a.sellerCode.compareTo(b.sellerCode));
  }

  @override
  Future<void> save(Collaborator collaborator) async {
    _byId[collaborator.id] = collaborator;
  }
}