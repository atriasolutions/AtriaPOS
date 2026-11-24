import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';

/// PIN de laboratorio solo para tests (no usar en producción).
const kTestPin = '2468';

const kTestDuenoId = 'a0000000-0000-4000-8000-000000000001';
const kTestSupervisorId = 'a0000000-0000-4000-8000-000000000002';
const kTestCajeroId = 'a0000000-0000-4000-8000-000000000003';

const kTestUserRut = '12.345.678-5';

Future<void> seedAuthUsers(
  UserRepository users,
  BcryptPinHasher hasher,
  StoreId storeId,
) async {
  final defs = [
  (
    id: kTestDuenoId,
    username: 'usr_dueno',
    role: UserRole.dueno,
    firstName: 'Dueño',
    lastName: 'Demo',
  ),
  (
    id: kTestSupervisorId,
    username: 'usr_supervisor',
    role: UserRole.supervisor,
    firstName: 'Supervisor',
    lastName: 'Demo',
  ),
  (
    id: kTestCajeroId,
    username: 'usr_cajero',
    role: UserRole.cajero,
    firstName: 'Cajero',
    lastName: 'Demo',
  ),
  ];
  final hash = hasher.hash(kTestPin);
  for (final d in defs) {
    await users.save(
      User(
        id: d.id,
        storeId: storeId,
        role: d.role,
        pinHash: hash,
        username: d.username,
        firstName: d.firstName,
        lastName: d.lastName,
        rut: kTestUserRut,
      ),
    );
  }
}