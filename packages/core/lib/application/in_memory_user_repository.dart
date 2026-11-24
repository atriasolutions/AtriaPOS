import '../domain/domain.dart';
import 'ports/user_repository.dart';

class InMemoryUserRepository implements UserRepository {
  final _users = <String, User>{};

  String _key(StoreId storeId, UserId userId) => '$storeId::$userId';

  @override
  Future<User?> findById(StoreId storeId, UserId userId) async {
    return _users[_key(storeId, userId)];
  }

  @override
  Future<User?> findByUsername(StoreId storeId, String username) async {
    final normalized = username.trim();
    for (final user in _users.values) {
      if (user.storeId == storeId && user.username == normalized) {
        return user;
      }
    }
    return null;
  }

  @override
  Future<void> save(User user) async {
    _users[_key(user.storeId, user.id)] = user;
  }

  @override
  Future<List<User>> listByStore(StoreId storeId) async {
    final list = _users.values.where((u) => u.storeId == storeId).toList();
    list.sort((a, b) => a.username.compareTo(b.username));
    return list;
  }

  @override
  Future<List<User>> listByStoreCreatedBetween(
    StoreId storeId,
    DateTime fromInclusive,
    DateTime toExclusive,
  ) async {
    return _users.values.where((u) {
      if (u.storeId != storeId) return false;
      final local = u.createdAt.toLocal();
      final from = fromInclusive.toLocal();
      final to = toExclusive.toLocal();
      return !local.isBefore(from) && local.isBefore(to);
    }).toList();
  }
}