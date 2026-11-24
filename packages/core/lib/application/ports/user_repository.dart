import '../../domain/domain.dart';

abstract class UserRepository {
  Future<User?> findById(StoreId storeId, UserId userId);

  Future<User?> findByUsername(StoreId storeId, String username);

  Future<void> save(User user);
}