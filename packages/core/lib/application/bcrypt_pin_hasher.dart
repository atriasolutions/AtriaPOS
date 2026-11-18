import 'package:bcrypt/bcrypt.dart';

import 'ports/pin_hasher.dart';

class BcryptPinHasher implements PinHasher {
  @override
  String hash(String pin) => BCrypt.hashpw(pin, BCrypt.gensalt());

  @override
  bool verify(String pin, String pinHash) => BCrypt.checkpw(pin, pinHash);
}