import 'package:adapters/drift_user_repository.dart';
import 'package:adapters/src/database.dart';
import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:drift/native.dart';
import 'package:test/test.dart';

void main() {
  test('SC-080-06 drift persiste y consulta por username', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final repo = DriftUserRepository(db);

    final user = User(
      id: 'usr_cajero',
      storeId: 't1',
      role: UserRole.cajero,
      pinHash: BcryptPinHasher().hash('2468'),
      username: 'usr_cajero',
      firstName: 'Cajero',
      lastName: 'Demo',
      rut: '12.345.678-5',
      createdAt: DateTime.utc(2026, 1, 1),
    );
    await repo.save(user);

    final byUsername = await repo.findByUsername('t1', 'usr_cajero');
    expect(byUsername, isNotNull);
    expect(byUsername!.firstName, 'Cajero');
    expect(byUsername.id, 'usr_cajero');
  });
}