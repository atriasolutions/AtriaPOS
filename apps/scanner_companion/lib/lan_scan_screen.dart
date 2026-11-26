import 'package:flutter/material.dart';

import 'companion_lan_client.dart';
import 'companion_ui_strings.dart';
import 'companion_work_panel.dart';

/// Visor aislado para tests. Producción usa [CompanionLanShell].
class LanScanScreen extends StatefulWidget {
  const LanScanScreen({
    super.key,
    required this.session,
    this.camera,
    this.now,
  });

  final CompanionLanSession session;
  final Widget Function(void Function(String code) onCode)? camera;
  final DateTime Function()? now;

  @override
  State<LanScanScreen> createState() => _LanScanScreenState();
}

class _LanScanScreenState extends State<LanScanScreen> {
  final _workKey = GlobalKey<CompanionWorkPanelState>();

  void _send() {
    _workKey.currentState?.triggerSend();
    setState(() {});
  }

  bool get _canSend => _workKey.currentState?.hasPending ?? false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(companionInBoxTitle),
            Text(
              companionLanModeLabel(widget.session.modeApi),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          IconButton(
            key: const Key('companion_lan_disconnect_button'),
            tooltip: companionLeaveBoxButtonLabel,
            onPressed: () {
              final nav = Navigator.of(context);
              if (nav.canPop()) nav.pop();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: CompanionWorkPanel(
              key: _workKey,
              session: widget.session,
              camera: widget.camera,
              now: widget.now,
              onPendingChanged: () => setState(() {}),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: FilledButton.icon(
                key: const Key('companion_lan_send_scan_button'),
                onPressed: _canSend ? _send : null,
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
          ),
        ],
      ),
    );
  }
}