import 'package:flutter/material.dart';

import 'companion_armed_scan.dart';
import 'companion_camera_view.dart';
import 'companion_lan_client.dart';
import 'companion_scan_display.dart';
import 'companion_ui_strings.dart';

/// Cámara de productos + estado + manual (sin AppBar ni CTA inferior).
class CompanionWorkPanel extends StatefulWidget {
  const CompanionWorkPanel({
    super.key,
    required this.session,
    this.camera,
    this.now,
    this.bottomInset = 0,
    this.onPendingChanged,
  });

  final CompanionLanSession session;
  final Widget Function(void Function(String code) onCode)? camera;
  final DateTime Function()? now;
  final double bottomInset;
  final VoidCallback? onPendingChanged;

  @override
  State<CompanionWorkPanel> createState() => CompanionWorkPanelState();
}

class CompanionWorkPanelState extends State<CompanionWorkPanel> {
  final _armed = CompanionArmedScan();
  final _manualCode = TextEditingController();
  String? _lastLabel;

  @override
  void initState() {
    super.initState();
    _bindSession(widget.session);
  }

  @override
  void didUpdateWidget(covariant CompanionWorkPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.session != widget.session) {
      _bindSession(widget.session);
    }
  }

  void _bindSession(CompanionLanSession session) {
    session.onScanAcknowledged = (code, productName) {
      if (!mounted) return;
      if (productName == null || productName.isEmpty) return;
      setState(() => _lastLabel = productName);
    };
  }

  @override
  void dispose() {
    widget.session.onScanAcknowledged = null;
    _manualCode.dispose();
    super.dispose();
  }

  DateTime _now() => widget.now?.call() ?? DateTime.now();

  bool get hasPending => _armed.pending != null;

  void handleCode(String raw) {
    if (!_armed.onDetect(raw, _now())) return;
    setState(() {});
    widget.onPendingChanged?.call();
  }

  String? triggerSend() {
    final code = _armed.trigger();
    if (code == null) return null;
    widget.session.sendScan(code);
    setState(() => _lastLabel = companionScanListoLabel(code));
    return code;
  }

  void sendManual() {
    final code = _manualCode.text.trim();
    if (code.isEmpty) return;
    widget.session.sendScan(code);
    _manualCode.clear();
    setState(() => _lastLabel = companionScanListoLabel(code));
  }

  String get _statusText {
    final pending = _armed.pending;
    if (pending != null) {
      return 'Listo: ${companionScanListoLabel(pending)}';
    }
    if (_lastLabel != null) return 'Último: $_lastLabel';
    return companionAimBarcodeHint;
  }

  @override
  Widget build(BuildContext context) {
    final camera = widget.camera;
    return Column(
      children: [
        Expanded(
          child: camera != null
              ? camera(handleCode)
              : CompanionCameraView(onCode: handleCode),
        ),
        if (hasPending)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              child: Chip(
                key: const Key('companion_lan_scan_ready_chip'),
                label: Text(_statusText),
              ),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              _statusText,
              key: const Key('companion_lan_scan_status'),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        KeyedSubtree(
          key: const Key('companion_lan_manual_section'),
          child: ExpansionTile(
            title: const Text(companionManualCodeSectionTitle),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: TextField(
                  key: const Key('companion_lan_manual_code_field'),
                  controller: _manualCode,
                  decoration: const InputDecoration(
                    labelText: companionManualCodeFieldLabel,
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => sendManual(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: OutlinedButton.icon(
                  key: const Key('companion_lan_manual_send_button'),
                  onPressed: sendManual,
                  icon: const Icon(Icons.keyboard),
                  label: const Text(companionManualSendButtonLabel),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: widget.bottomInset),
      ],
    );
  }
}