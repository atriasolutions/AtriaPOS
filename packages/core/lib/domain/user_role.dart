enum UserRole {
  dueno('DUENO'),
  supervisor('SUPERVISOR'),
  cajero('CAJERO');

  const UserRole(this.apiValue);

  final String apiValue;

  static UserRole fromApi(String value) {
    return UserRole.values.firstWhere(
      (r) => r.apiValue == value.trim().toUpperCase(),
      orElse: () => UserRole.cajero,
    );
  }

  /// Etiqueta UI plantilla Atria POS (revisión 2).
  String get displayLabelAtriaPos => switch (this) {
        UserRole.dueno => 'Jefe de tienda',
        UserRole.supervisor => 'Jefe de turno',
        UserRole.cajero => 'Cajero',
      };
}