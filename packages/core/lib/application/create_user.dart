import '../domain/domain.dart';
import 'auth_helpers.dart';
import 'ports/pin_hasher.dart';
import 'ports/session_provider.dart';
import 'ports/user_repository.dart';

class CreateUserInput {
  const CreateUserInput({
    required this.storeId,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.rut,
    required this.role,
    required this.pin,
  });

  final StoreId storeId;
  final String username;
  final String firstName;
  final String lastName;
  final String rut;
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

    final username = CredentialPolicy.normalizeUsername(input.username);
    CredentialPolicy.validateUsername(username);
    CredentialPolicy.validatePin(input.pin);

    if (input.pin.length < 4) {
      throw const ValidationFailure('El PIN debe tener al menos 4 dígitos');
    }

    final firstName = input.firstName.trim();
    final lastName = input.lastName.trim();
    if (firstName.isEmpty) {
      throw const ValidationFailure('Ingrese el nombre');
    }
    if (lastName.isEmpty) {
      throw const ValidationFailure('Ingrese el apellido');
    }

    if (!RutChile.isValid(input.rut)) {
      throw const ValidationFailure('RUT de usuario inválido');
    }
    final rutNormalized = RutChile.formatDisplay(input.rut);

    final existingByUsername =
        await _users.findByUsername(input.storeId, username);
    if (existingByUsername != null) {
      throw ConflictFailure(
        'Ya existe un usuario con ese nombre de usuario',
        details: {'username': username},
      );
    }

    final session = requireActiveSession(_sessions);
    final user = User(
      id: newUserId(),
      storeId: input.storeId,
      role: input.role,
      pinHash: _hasher.hash(input.pin),
      username: username,
      firstName: firstName,
      lastName: lastName,
      rut: rutNormalized,
      createdAt: DateTime.now().toUtc(),
      createdByUserId: session.userId,
    );
    await _users.save(user);
    return user;
  }
}