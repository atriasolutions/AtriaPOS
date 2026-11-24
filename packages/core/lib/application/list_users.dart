import '../domain/domain.dart';
import 'auth_helpers.dart';
import 'ports/session_provider.dart';
import 'ports/user_repository.dart';

class ListUsers {
  ListUsers(this._users, this._sessions);

  final UserRepository _users;
  final SessionProvider _sessions;

  Future<List<User>> call(StoreId storeId) async {
    AuthPolicy.require(
      requireActiveSession(_sessions),
      Permission.gestionarUsuarios,
    );
    return _users.listByStore(storeId);
  }
}