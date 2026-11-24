import 'auth_session.dart';
import 'failures.dart';
import 'permission.dart';
import 'role_capabilities.dart';
import 'user_role.dart';

class AuthPolicy {
  static bool allows(UserRole role, Permission permission) {
    return RoleCapabilities.forRole(role).contains(permission);
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