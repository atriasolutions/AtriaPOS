import 'auth_session.dart';
import 'user_role.dart';

class User {
  User({
    required this.id,
    required this.storeId,
    required this.role,
    required this.pinHash,
    required this.displayName,
  });

  final UserId id;
  final String storeId;
  final UserRole role;
  final String pinHash;
  final String displayName;
}