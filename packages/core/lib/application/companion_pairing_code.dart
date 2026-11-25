import 'dart:math';

abstract final class CompanionPairingCode {
  static const _chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

  static String generate({int length = 6, Random? random}) {
    final rng = random ?? Random.secure();
    final buffer = StringBuffer();
    for (var i = 0; i < length; i++) {
      buffer.write(_chars[rng.nextInt(_chars.length)]);
    }
    return buffer.toString();
  }
}