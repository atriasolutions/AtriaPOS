import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  group('RoleCapabilities RF-081', () {
    test('SC-081-01 cajero vender y consultar stock', () {
      final caps = RoleCapabilities.forRole(UserRole.cajero);
      expect(caps, contains(Permission.vender));
      expect(caps, contains(Permission.consultarStock));
      expect(caps, isNot(contains(Permission.consultarReportes)));
    });

    test('SC-081-02 supervisor hereda y auditoría', () {
      final caps = RoleCapabilities.forRole(UserRole.supervisor);
      expect(caps, contains(Permission.vender));
      expect(caps, contains(Permission.consultarAuditoria));
      expect(caps, contains(Permission.cambiarProducto));
      expect(caps, isNot(contains(Permission.gestionarUsuarios)));
    });

    test('SC-081-03 dueño hereda supervisor y usuarios', () {
      final sup = RoleCapabilities.forRole(UserRole.supervisor);
      final owner = RoleCapabilities.forRole(UserRole.dueno);
      expect(owner, containsAll(sup));
      expect(owner, contains(Permission.gestionarUsuarios));
      expect(owner, contains(Permission.gestionarPlanilla));
    });

    test('SC-083-03 supervisor sin gestionar planilla', () {
      final caps = RoleCapabilities.forRole(UserRole.supervisor);
      expect(caps, isNot(contains(Permission.gestionarPlanilla)));
    });
  });
}