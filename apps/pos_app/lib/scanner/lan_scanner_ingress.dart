import 'dart:async';

import 'scanner_ingress.dart';

/// Ingress alimentado por el servidor companion LAN (scan stream).
class LanScannerIngress implements ScannerIngress {
  LanScannerIngress(Stream<String> scanSource) {
    _sourceSub = scanSource.listen(
      _controller.add,
      onError: _controller.addError,
    );
  }

  final _controller = StreamController<String>.broadcast();
  late final StreamSubscription<String> _sourceSub;

  @override
  Stream<String> get scans => _controller.stream;

  @override
  Future<void> start() async {}

  @override
  Future<void> stop() async {}

  @override
  void dispose() {
    unawaited(_sourceSub.cancel());
    unawaited(_controller.close());
  }
}