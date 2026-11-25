import 'dart:async';

import 'package:core/application/application.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Tokens con WebSocket companion abierto (SLICE-111).
class CompanionLanLiveRegistry implements CompanionLiveSessions {
  final Map<String, Set<WebSocketChannel>> _channels = {};
  final StreamController<void> _statusChanges = StreamController.broadcast();

  Stream<void> get statusChanges => _statusChanges.stream;

  void notifyStatusChanged() => _statusChanges.add(null);

  @override
  bool isLive(String token) {
    final set = _channels[token];
    return set != null && set.isNotEmpty;
  }

  void register(String token, WebSocketChannel channel) {
    _channels.putIfAbsent(token, () => {}).add(channel);
    _statusChanges.add(null);
  }

  void unregister(String token, WebSocketChannel channel) {
    final set = _channels[token];
    if (set == null) return;
    set.remove(channel);
    if (set.isEmpty) {
      _channels.remove(token);
    }
    _statusChanges.add(null);
  }

  @override
  Future<void> disconnect(String token) async {
    final set = _channels.remove(token);
    if (set == null) return;
    for (final channel in set) {
      await channel.sink.close();
    }
    _statusChanges.add(null);
  }

  void dispose() {
    unawaited(_statusChanges.close());
  }
}