abstract final class CompanionLanConstants {
  static const int defaultPort = 8765;
  static const String shortLinkPathPrefix = '/c';
  static const String wsPath = '/v0/ws/companion';
  static const Duration offerTtl = Duration(minutes: 30);
  static const Duration sessionTtl = Duration(minutes: 30);
  static const int pairingCodeLength = 6;
}