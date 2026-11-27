import 'package:core/domain/domain.dart';
import 'package:flutter/material.dart';

class InventoryStatusChip extends StatelessWidget {
  const InventoryStatusChip({
    super.key,
    required this.status,
    this.delta,
    this.semanticsKey,
  });

  final InventoryCountLineStatus status;
  final int? delta;
  final Key? semanticsKey;

  String get _label => switch (status) {
        InventoryCountLineStatus.sinContar => 'Sin contar',
        InventoryCountLineStatus.contado => 'Contado',
        InventoryCountLineStatus.diferencias => 'Diferencias',
      };

  IconData get _icon => switch (status) {
        InventoryCountLineStatus.sinContar => Icons.radio_button_unchecked,
        InventoryCountLineStatus.contado => Icons.check_circle_outline,
        InventoryCountLineStatus.diferencias => Icons.warning_amber_rounded,
      };

  String get semanticsLabel {
    if (status == InventoryCountLineStatus.diferencias && delta != null) {
      final kind = delta! > 0 ? 'Sobrante' : 'Faltante';
      return '$kind: $_label, diferencia ${delta! > 0 ? '+' : ''}$delta';
    }
    return _label;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final (bg, fg) = switch (status) {
      InventoryCountLineStatus.sinContar => (
          cs.surfaceContainerHighest,
          cs.onSurfaceVariant,
        ),
      InventoryCountLineStatus.contado => (
          cs.primaryContainer,
          cs.onPrimaryContainer,
        ),
      InventoryCountLineStatus.diferencias => (
          cs.errorContainer,
          cs.onErrorContainer,
        ),
    };

    return Semantics(
      key: semanticsKey,
      label: semanticsLabel,
      liveRegion: true,
      child: Chip(
        avatar: Icon(_icon, size: 18, color: fg),
        label: Text(_label),
        backgroundColor: bg,
        labelStyle: TextStyle(color: fg, fontWeight: FontWeight.w600),
        visualDensity: VisualDensity.comfortable,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      ),
    );
  }
}