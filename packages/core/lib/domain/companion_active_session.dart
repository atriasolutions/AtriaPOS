import 'companion_mode.dart';
import 'store_id.dart';

class CompanionActiveSession {
  CompanionActiveSession({
    required this.token,
    required this.storeId,
    required this.mode,
    required this.expiresAt,
    required this.createdAt,
  });

  final String token;
  final StoreId storeId;
  final CompanionMode mode;
  final DateTime expiresAt;
  final DateTime createdAt;

  bool get isExpired => DateTime.now().toUtc().isAfter(expiresAt);
}