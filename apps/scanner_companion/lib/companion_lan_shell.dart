import 'package:flutter/material.dart';

import 'companion_camera_view.dart';
import 'companion_lan_client.dart';
import 'companion_qr_link.dart';
import 'companion_ui_strings.dart';
import 'companion_work_panel.dart';

/// Pantalla única LAN: desconectado (vincular) ↔ conectado (escanear).
class CompanionLanShell extends StatefulWidget {
  const CompanionLanShell({
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
  State<CompanionLanShell> createState() => _CompanionLanShellState();
}

class _CompanionLanShellState extends State<CompanionLanShell> {
  final _url = TextEditingController();
  final _workPanelKey = GlobalKey<CompanionWorkPanelState>();
  CompanionLanSession? _session;
  String? _error;
  bool _busy = false;
  bool _moreOptionsExpanded = false;

  @override
  void dispose() {
    _url.dispose();
    super.dispose();
  }

  bool get _connected => _session != null;

  Future<void> _connectLink() async {
    if (_url.text.trim().isEmpty) {
      setState(() => _error = companionConnectValidationEmpty);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final session = await widget.client.connectLink(_url.text);
      if (!mounted) return;
      setState(() {
        _session = session;
        _busy = false;
        _moreOptionsExpanded = false;
        _url.clear();
      });
    } on CompanionLinkRejected {
      if (!mounted) return;
      setState(() {
        _error = companionLinkRejectedMessage;
        _busy = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = companionConnectFailedMessage;
        _busy = false;
      });
    }
  }

  Future<void> _readQrAndConnect() async {
    final allowed = await (widget.ensureCamera ?? ensureCompanionCamera)();
    if (!mounted) return;
    if (!allowed) {
      setState(() => _error = cameraPermissionMessage);
      return;
    }
    final value = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(
        builder: (_) => CompanionQrScanPage(qrReader: widget.qrReader),
      ),
    );
    if (!mounted || value == null || value.isEmpty) return;
    _url.text = value;
    await _connectLink();
  }

  void _disconnect() {
    setState(() {
      _session = null;
      _error = null;
      _moreOptionsExpanded = false;
      _url.clear();
    });
  }

  void _sendArmed() {
    _workPanelKey.currentState?.triggerSend();
    setState(() {});
  }

  bool get _canSend {
    return _workPanelKey.currentState?.hasPending ?? false;
  }

  Widget _buildBottomDisconnected() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            FilledButton.icon(
              key: const Key('companion_lan_read_qr_button'),
              onPressed: _busy ? null : _readQrAndConnect,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text(companionLinkWithBoxButtonLabel),
            ),
            TextButton(
              key: const Key('companion_lan_more_options'),
              onPressed: _busy
                  ? null
                  : () => setState(
                        () => _moreOptionsExpanded = !_moreOptionsExpanded,
                      ),
              child: const Text(companionMoreOptionsTitle),
            ),
            if (_moreOptionsExpanded) ...[
              TextField(
                key: const Key('companion_lan_url_field'),
                controller: _url,
                decoration: const InputDecoration(
                  labelText: companionManualLinkFieldLabel,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                key: const Key('companion_lan_connect_button'),
                onPressed: _busy ? null : _connectLink,
                icon: const Icon(Icons.link),
                label: const Text(companionUsePastedLinkButtonLabel),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBottomConnected() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: FilledButton.icon(
          key: const Key('companion_lan_send_scan_button'),
          onPressed: _canSend ? _sendArmed : null,
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(56),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          icon: const Icon(Icons.document_scanner),
          label: const Text('Escanear'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = _session;
  return Scaffold(
      appBar: AppBar(
        title: _connected
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(companionInBoxTitle),
                  Text(
                    companionLanModeLabel(session!.modeApi),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              )
            : const Text(companionConnectTitle),
        actions: _connected
            ? [
                IconButton(
                  key: const Key('companion_lan_disconnect_button'),
                  tooltip: companionLeaveBoxButtonLabel,
                  onPressed: _disconnect,
                  icon: const Icon(Icons.logout),
                ),
              ]
            : null,
      ),
      body: Column(
        children: [
          Expanded(
            child: _connected
                ? CompanionWorkPanel(
                    key: _workPanelKey,
                    session: session!,
                    camera: widget.scanCamera,
                    onPendingChanged: () => setState(() {}),
                  )
                : Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(companionConnectIntro),
                        if (_error != null) ...[
                          const SizedBox(height: 16),
                          Text(
                            _error!,
                            key: const Key('companion_lan_error'),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                          if (_error == cameraPermissionMessage) ...[
                            const SizedBox(height: 8),
                            OutlinedButton.icon(
                              key: const Key('companion_camera_settings_button'),
                              onPressed: () {
                                final open =
                                    widget.openSettings ?? openCompanionCameraSettings;
                                open();
                              },
                              icon: const Icon(Icons.settings),
                              label: const Text('Abrir ajustes de la app'),
                            ),
                          ],
                        ],
                        const Spacer(),
                      ],
                    ),
                  ),
          ),
          if (_connected) _buildBottomConnected() else _buildBottomDisconnected(),
        ],
      ),
    );
  }
}

/// Lectura única del QR de empareje.
class CompanionQrScanPage extends StatefulWidget {
  const CompanionQrScanPage({super.key, this.qrReader});

  final Widget Function(void Function(String value) onCode)? qrReader;

  @override
  State<CompanionQrScanPage> createState() => _CompanionQrScanPageState();
}

class _CompanionQrScanPageState extends State<CompanionQrScanPage> {
  var _handled = false;

  void _accept(String raw) {
    if (_handled) return;
    if (parseCompanionQrLink(raw) == null) return;
    _handled = true;
    final nav = Navigator.of(context);
    if (!nav.canPop()) return;
    nav.pop(raw.trim());
  }

  @override
  Widget build(BuildContext context) {
    final reader = widget.qrReader;
    return Scaffold(
      appBar: AppBar(title: const Text(companionScanBoxCodeTitle)),
      body: reader != null
          ? reader(_accept)
          : CompanionCameraView(
              onlyPairingLink: true,
              onCode: _accept,
            ),
    );
  }
}