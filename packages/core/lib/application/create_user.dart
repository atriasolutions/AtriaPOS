import '../domain/domain.dart';
import 'auth_helpers.dart';
import 'ports/pin_hasher.dart';
import 'ports/session_provider.dart';
import 'ports/user_repository.dart';

class CreateUserInput {
  const CreateUserInput({
    required this.storeId,
    required this.userId,
    required this.displayName,
    required this.role,
    required this.pin,
  });

  final StoreId storeId;
  final UserId userId;
  final String displayName;
  final UserRole role;
  final String pin;
}

class CreateUser {
  CreateUser(this._users, this._hasher, this._sessions);

  final UserRepository _users;
  final PinHasher _hasher;
  final SessionProvider _sessions;

  Future<User> call(CreateUserInput input) async {
    AuthPolicy.require(
      requireActiveSession(_sessions),
      Permission.gestionarUsuarios,
    );

    if (input.pin.length < 4) {
      throw const ValidationFailure('El PIN debe tener al menos 4 dígitos');
    }

    final existing = await _users.findById(input.storeId, input.userId);
    if (existing != null) {
      throw ConflictFailure(
        'Ya existe un usuario con ese identificador',
        details: {'userId': input.userId},
      );
    }

    final user = User(
      id: input.userId,
      storeId: input.storeId,
      role: input.role,
      pinHash: _hasher.hash(input.pin),
      displayName: input.displayName,
    );
    await _users.save(user);
    return user;
  }
}