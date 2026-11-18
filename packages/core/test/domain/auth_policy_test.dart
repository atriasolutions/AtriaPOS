import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  group('AuthPolicy RF-002', () {
    test('todos pueden vender', () {
      for (final role in UserRole.values) {
        expect(AuthPolicy.allows(role, Permission.vender), isTrue);
      }
    });

    test('cajero no ajusta inventario ni cierra caja', () {
      expect(
        AuthPolicy.allows(UserRole.cajero, Permission.ajustarInventario),
        isFalse,
      );
      expect(AuthPolicy.allows(UserRole.cajero, Permission.cerrarCaja), isFalse);
      expect(
        AuthPolicy.allows(UserRole.cajero, Permission.configurarCatalogo),
        isFalse,
      );
    });

    test('supervisor opera inventario y caja', () {
      expect(
        AuthPolicy.allows(UserRole.supervisor, Permission.ajustarInventario),
        isTrue,
      );
      expect(
        AuthPolicy.allows(UserRole.supervisor, Permission.cerrarCaja),
        isTrue,
      );
      expect(
        AuthPolicy.allows(UserRole.supervisor, Permission.configurarCatalogo),
        isTrue,
      );
      expect(
        AuthPolicy.allows(UserRole.supervisor, Permission.gestionarUsuarios),
        isFalse,
      );
    });

    test('solo dueño gestiona usuarios', () {
      expect(
        AuthPolicy.allows(UserRole.dueno, Permission.gestionarUsuarios),
        isTrue,
      );
    });

    test('require lanza PERMISO_DENEGADO', () {
      final session = AuthSession(
        userId: 'usr_cajero',
        role: UserRole.cajero,
        expiresAt: DateTime.now().toUtc().add(const Duration(hours: 1)),
      );
      expect(
        () => AuthPolicy.require(session, Permission.ajustarInventario),
        throwsA(isA<ForbiddenFailure>()),
      );
    });
  });
}