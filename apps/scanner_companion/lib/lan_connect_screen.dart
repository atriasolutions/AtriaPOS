import 'package:flutter/material.dart';

import 'companion_lan_client.dart';
import 'companion_lan_shell.dart';

/// Empareja con la caja por código o enlace pegado (red local).
class LanConnectScreen extends StatelessWidget {
  const LanConnectScreen({
    super.key,
    required this.client,
    this.qrReader,
    this.scanCamera,
    this.ensureCamera,
    this.openSettings,
  });

  final CompanionLanClient client;
  final Widget Function(void Function(String value) onCode)? qrReader;
  final Widget Function(void Function(String code) onCode)? scanCamera;
  final Future<bool> Function()? ensureCamera;
  final Future<void> Function()? openSettings;

  @override
  Widget build(BuildContext context) {
    return CompanionLanShell(
      client: client,
      qrReader: qrReader,
      scanCamera: scanCamera,
      ensureCamera: ensureCamera,
      openSettings: openSettings,
    );
  }
}