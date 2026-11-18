abstract class PinHasher {
  String hash(String pin);

  bool verify(String pin, String pinHash);
}