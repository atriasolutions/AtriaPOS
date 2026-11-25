import 'companion_mode.dart';
import 'store_id.dart';

class CompanionPairingOffer {
  CompanionPairingOffer({
    required this.storeId,
    required this.pairingCode,
    required this.mode,
    required this.expiresAt,
    required this.createdAt,
  });

  final StoreId storeId;
  final String pairingCode;
  final CompanionMode mode;
  final DateTime expiresAt;
  final DateTime createdAt;

  bool get isExpired => DateTime.now().toUtc().isAfter(expiresAt);

  bool matchesCode(String raw) =>
      pairingCode.toUpperCase() == raw.trim().toUpperCase();
}