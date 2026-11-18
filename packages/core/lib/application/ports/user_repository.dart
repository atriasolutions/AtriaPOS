import '../../domain/domain.dart';

abstract class UserRepository {
  Future<User?> findById(StoreId storeId, UserId userId);

  Future<void> save(User user);
}