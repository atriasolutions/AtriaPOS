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
}