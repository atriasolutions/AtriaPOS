import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';

/// PIN de laboratorio solo para tests (no usar en producción).
const kTestPin = '2468';

Future<void> seedAuthUsers(
  UserRepository users,
  BcryptPinHasher hasher,
  StoreId storeId,
) async {
  final defs = [
    (id: 'usr_dueno', role: UserRole.dueno, name: 'Dueño'),
    (id: 'usr_supervisor', role: UserRole.supervisor, name: 'Supervisor'),
    (id: 'usr_cajero', role: UserRole.cajero, name: 'Cajero'),
  ];
  final hash = hasher.hash(kTestPin);
  for (final d in defs) {
    await users.save(
      User(
        id: d.id,
        storeId: storeId,
        role: d.role,
        pinHash: hash,
        displayName: d.name,
      ),
    );
  }
}