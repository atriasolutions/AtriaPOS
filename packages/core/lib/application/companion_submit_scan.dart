import '../domain/domain.dart';
import '../scanner/scan_payload_codec.dart';
import '../scanner/scanner_ble_constants.dart';
import 'ports/companion_pairing_repository.dart';
import 'ports/trusted_clock.dart';

class CompanionSubmitScanInput {
  const CompanionSubmitScanInput({
    required this.token,
    required this.rawCode,
  });

  final String token;
  final String rawCode;
}

class CompanionSubmitScanResult {
  const CompanionSubmitScanResult({
    required this.storeId,
    required this.mode,
    required this.code,
  });

  final StoreId storeId;
  final CompanionMode mode;
  final String code;
}

class CompanionSubmitScan {
  CompanionSubmitScan(
    this._repo, [
    TrustedClock? clock,
  ]) : _clock = clock ?? MutableTrustedClock();

  final CompanionPairingRepository _repo;
  final TrustedClock _clock;

  DateTime? _lastScanAt;
  String? _lastCode;

  Future<CompanionSubmitScanResult?> call(CompanionSubmitScanInput input) async {
    final session = await _repo.findByToken(input.token);
    if (session == null || session.isExpired) {
      throw const ValidationFailure('Sesión companion inválida o expirada');
    }
    final decoded = decodeScanPayload(input.rawCode);
    if (decoded == null || decoded.isEmpty) {
      throw const ValidationFailure('Código de barras inválido');
    }
    final now = _clock.now();
    if (_lastCode == decoded &&
        _lastScanAt != null &&
        now.difference(_lastScanAt!) < ScannerBleConstants.debounceDelay) {
      return null;
    }
    _lastCode = decoded;
    _lastScanAt = now;
    return CompanionSubmitScanResult(
      storeId: session.storeId,
      mode: session.mode,
      code: decoded,
    );
  }
}