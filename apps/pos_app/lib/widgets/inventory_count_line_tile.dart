import 'package:core/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/atria_touch_targets.dart';
import 'inventory_status_chip.dart';

class InventoryCountLineTile extends StatelessWidget {
  const InventoryCountLineTile({
    super.key,
    required this.productId,
    required this.name,
    required this.systemStock,
    required this.unitsSoldInShift,
    required this.countedQty,
    this.countField,
  });

  final String productId;
  final String name;
  final int systemStock;
  final int unitsSoldInShift;
  final int? countedQty;
  final Widget? countField;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final resolution = resolveInventoryCountLineStatus(systemStock, countedQty);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    key: Key('inventory_close_name_$productId'),
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                InventoryStatusChip(
                  semanticsKey: Key('inventory_line_status_$productId'),
                  status: resolution.status,
                  delta: resolution.delta,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Stock sistema: $systemStock',
              key: Key('inventory_close_system_$productId'),
              style: theme.textTheme.bodyLarge,
            ),
            Text(
              'Vendidos en turno: $unitsSoldInShift',
              key: Key('inventory_close_sold_$productId'),
            ),
            if (resolution.status == InventoryCountLineStatus.diferencias &&
                resolution.delta != null) ...[
              const SizedBox(height: 6),
              Semantics(
                label: resolution.delta! > 0
                    ? 'Sobrante ${resolution.delta}'
                    : 'Faltante ${-resolution.delta!}',
                liveRegion: true,
                child: Text(
                  resolution.delta! > 0
                      ? 'Sobrante: +${resolution.delta}'
                      : 'Faltante: ${resolution.delta}',
                  key: Key('inventory_line_delta_$productId'),
                  style: theme.textTheme.titleMedium?.copyWith(color: cs.error),
                ),
              ),
            ],
            if (countField != null) ...[
              const SizedBox(height: 10),
              countField!,
            ] else if (countedQty != null) ...[
              const SizedBox(height: 4),
              Text(
                'Cantidad contada: $countedQty',
                style: theme.textTheme.bodyLarge,
              ),
            ],
          ],
        ),
      ),
    );
  }

  static Widget countedField({
    required Key fieldKey,
    required TextEditingController controller,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextField(
      key: fieldKey,
      controller: controller,
      decoration: touchTextFieldDecoration(labelText: 'Cantidad contada'),
      keyboardType: TextInputType.number,
      inputFormatters: inputFormatters,
    );
  }
}