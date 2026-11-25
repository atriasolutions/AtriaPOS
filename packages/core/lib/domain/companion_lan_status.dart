import 'companion_mode.dart';
import 'store_id.dart';

enum CompanionLanPhase {
  none,
  sessionOnly,
  live,
}

class CompanionLanStatus {
  const CompanionLanStatus({
    required this.storeId,
    required this.phase,
    this.mode,
  });

  final StoreId storeId;
  final CompanionLanPhase phase;
  final CompanionMode? mode;

  bool get hasActiveSession =>
      phase == CompanionLanPhase.sessionOnly ||
      phase == CompanionLanPhase.live;
}