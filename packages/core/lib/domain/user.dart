import 'auth_session.dart';
import 'user_role.dart';

class User {
  User({
    required this.id,
    required this.storeId,
    required this.role,
    required this.pinHash,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.rut,
    required this.createdAt,
    this.createdByUserId,
  });

  final UserId id;
  final String storeId;
  final UserRole role;
  final String pinHash;
  final String username;
  final String firstName;
  final String lastName;
  final String rut;
  final DateTime createdAt;
  final String? createdByUserId;

  /// Nombre visible para listas y auditoría (RF-080).
  String get displayName {
    final full = '${firstName.trim()} ${lastName.trim()}'.trim();
    return full.isEmpty ? username : full;
  }
}