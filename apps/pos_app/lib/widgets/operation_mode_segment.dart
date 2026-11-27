import 'package:flutter/material.dart';

import '../theme/atria_touch_targets.dart';

/// Manual = false, Por escaneo = true.
class OperationModeSegment extends StatelessWidget {
  const OperationModeSegment({
    super.key,
    required this.scanSelected,
    required this.onChanged,
    required this.manualKey,
    required this.scanKey,
    this.enabled = true,
  });

  final bool scanSelected;
  final ValueChanged<bool> onChanged;
  final Key manualKey;
  final Key scanKey;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Modo de operación',
      child: SegmentedButton<bool>(
        segments: [
          ButtonSegment<bool>(
            value: false,
            label: KeyedSubtree(
              key: manualKey,
              child: const Text('Manual'),
            ),
            icon: const Icon(Icons.edit_outlined, size: 20),
          ),
          ButtonSegment<bool>(
            value: true,
            label: KeyedSubtree(
              key: scanKey,
              child: const Text('Por escaneo'),
            ),
            icon: const Icon(Icons.qr_code_scanner_outlined, size: 20),
          ),
        ],
        selected: {scanSelected},
        showSelectedIcon: false,
        onSelectionChanged: enabled
            ? (selection) => onChanged(selection.first)
            : null,
        style: ButtonStyle(
          minimumSize: WidgetStateProperty.all(
            const Size(0, kMinTouchHeight),
          ),
        ),
      ),
    );
  }
}