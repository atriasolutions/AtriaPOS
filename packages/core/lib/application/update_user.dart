import '../domain/domain.dart';
import 'auth_helpers.dart';
import 'ports/pin_hasher.dart';
import 'ports/session_provider.dart';
import 'ports/user_repository.dart';

class UpdateUserInput {
  const UpdateUserInput({
    required this.storeId,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.rut,
    required this.role,
    this.newPin,
  });

  final StoreId storeId;
  final UserId userId;
  final String firstName;
  final String lastName;
  final String rut;
  final UserRole role;
  final String? newPin;
}

class UpdateUser {
  UpdateUser(this._users, this._hasher, this._sessions);

  final UserRepository _users;
  final PinHasher _hasher;
  final SessionProvider _sessions;

  Future<User> call(UpdateUserInput input) async {
    AuthPolicy.require(
      requireActiveSession(_sessions),
      Permission.gestionarUsuarios,
    );

    final existing = await _users.findById(input.storeId, input.userId);
    if (existing == null) {
      throw NotFoundFailure(
        'Usuario no encontrado',
        details: {'userId': input.userId},
      );
    }

    if (input.role == UserRole.dueno && existing.role != UserRole.dueno) {
      throw const ValidationFailure('No puede asignar rol dueño');
    }

    var role = input.role;
    if (existing.role == UserRole.dueno) {
      if (input.role != UserRole.dueno) {
        throw const ValidationFailure('No puede cambiar el rol del dueño');
      }
      role = UserRole.dueno;
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

    var pinHash = existing.pinHash;
    final pin = input.newPin?.trim();
    if (pin != null && pin.isNotEmpty) {
      CredentialPolicy.validatePin(pin);
      if (pin.length < 4) {
        throw const ValidationFailure('El PIN debe tener al menos 4 dígitos');
      }
      pinHash = _hasher.hash(pin);
    }

    final user = User(
      id: existing.id,
      storeId: existing.storeId,
      role: role,
      pinHash: pinHash,
      username: existing.username,
      firstName: firstName,
      lastName: lastName,
      rut: rutNormalized,
      createdAt: existing.createdAt,
      createdByUserId: existing.createdByUserId,
    );
    await _users.save(user);
    return user;
  }
}