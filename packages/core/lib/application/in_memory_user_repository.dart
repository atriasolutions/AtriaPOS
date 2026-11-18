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
  Future<void> save(User user) async {
    _users[_key(user.storeId, user.id)] = user;
  }
}