import 'auth_session.dart';
import 'failures.dart';
import 'permission.dart';
import 'user_role.dart';

class AuthPolicy {
  static bool allows(UserRole role, Permission permission) {
    return switch (permission) {
      Permission.vender => true,
      Permission.ajustarInventario =>
        role == UserRole.dueno || role == UserRole.supervisor,
      Permission.cerrarCaja =>
        role == UserRole.dueno || role == UserRole.supervisor,
      Permission.configurarCatalogo =>
        role == UserRole.dueno || role == UserRole.supervisor,
      Permission.gestionarUsuarios => role == UserRole.dueno,
    };
  }

  static void require(AuthSession session, Permission permission) {
    session.requireActive();
    if (!allows(session.role, permission)) {
      throw ForbiddenFailure(
        'No tiene permiso para esta acción',
      );
    }
  }
}