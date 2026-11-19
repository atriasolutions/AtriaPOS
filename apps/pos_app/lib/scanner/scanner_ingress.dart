import 'dart:async';

/// Entrada de lecturas desde escáner externo (BLE companion o fake en tests).
abstract class ScannerIngress {
  Stream<String> get scans;
  Future<void> start();
  Future<void> stop();
  void dispose();
}

class StreamScannerIngress implements ScannerIngress {
  StreamScannerIngress({Stream<String>? source}) {
    _controller = StreamController<String>.broadcast(
      onListen: () {},
    );
    _sourceSub = source?.listen(_controller.add);
  }

  late final StreamController<String> _controller;
  StreamSubscription<String>? _sourceSub;

  void push(String value) {
    if (!_controller.isClosed) {
      _controller.add(value);
    }
  }

  @override
  Stream<String> get scans => _controller.stream;

  @override
  Future<void> start() async {}

  @override
  Future<void> stop() async {}

  @override
  void dispose() {
    _sourceSub?.cancel();
    _controller.close();
  }
}