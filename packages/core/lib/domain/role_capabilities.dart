import 'permission.dart';
import 'user_role.dart';

/// Matriz Atria POS con herencia Cajero → Jefe de turno → Jefe de tienda (DEC-048).
class RoleCapabilities {
  static const _cajero = {
    Permission.vender,
    Permission.consultarStock,
  };

  static const _supervisorExtra = {
    Permission.listarVentasTurno,
    Permission.consultarReportes,
    Permission.consultarAuditoria,
    Permission.consultarCertificado,
    Permission.ajustarInventario,
    Permission.cerrarCaja,
    Permission.configurarCatalogo,
    Permission.anularVenta,
  };

  static const _duenoExtra = {
    Permission.gestionarUsuarios,
  };

  static Set<Permission> forRole(UserRole role) {
    return switch (role) {
      UserRole.cajero => {..._cajero},
      UserRole.supervisor => {..._cajero, ..._supervisorExtra},
      UserRole.dueno => {..._cajero, ..._supervisorExtra, ..._duenoExtra},
    };
  }
}