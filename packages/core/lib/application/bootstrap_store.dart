import '../domain/domain.dart';
import 'ports/pin_hasher.dart';
import 'ports/session_provider.dart';
import 'ports/store_repository.dart';
import 'ports/user_repository.dart';

class BootstrapStoreInput {
  const BootstrapStoreInput({
    required this.rut,
    required this.legalName,
    required this.businessLine,
    required this.ownerDisplayName,
    required this.ownerPin,
    this.ownerUserId = 'usr_dueno',
  });

  final String rut;
  final String legalName;
  final String businessLine;
  final String ownerDisplayName;
  final String ownerPin;
  final UserId ownerUserId;
}

class BootstrapStoreResult {
  const BootstrapStoreResult({
    required this.store,
    required this.user,
    required this.session,
  });

  final Store store;
  final User user;
  final AuthSession session;
}

class BootstrapStore {
  BootstrapStore(
    this._stores,
    this._users,
    this._hasher,
    this._sessions, {
    this.sessionTtl = const Duration(minutes: 15),
  });

  final StoreRepository _stores;
  final UserRepository _users;
  final PinHasher _hasher;
  final SessionProvider _sessions;
  final Duration sessionTtl;

  Future<BootstrapStoreResult> call(BootstrapStoreInput input) async {
    if (await _stores.count() > 0) {
      throw const ConflictFailure('Ya existe una tienda en este dispositivo');
    }
    if (input.ownerPin.length < 4) {
      throw const ValidationFailure('El PIN debe tener al menos 4 dígitos');
    }
    final displayName = input.ownerDisplayName.trim();
    if (displayName.isEmpty) {
      throw const ValidationFailure('Ingrese el nombre del dueño');
    }

    final store = Store.create(
      id: newStoreId(),
      rutRaw: input.rut,
      legalName: input.legalName,
      businessLine: input.businessLine,
    );
    await _stores.save(store);

    final user = User(
      id: input.ownerUserId,
      storeId: store.id,
      role: UserRole.dueno,
      pinHash: _hasher.hash(input.ownerPin),
      displayName: displayName,
    );
    await _users.save(user);

    final session = AuthSession(
      userId: user.id,
      role: user.role,
      expiresAt: DateTime.now().toUtc().add(sessionTtl),
    );
    _sessions.setSession(session);

    return BootstrapStoreResult(store: store, user: user, session: session);
  }
}