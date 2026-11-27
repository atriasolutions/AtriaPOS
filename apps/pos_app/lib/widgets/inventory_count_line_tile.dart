import 'package:core/domain/domain.dart';
import 'package:flutter/material.dart';

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

  String _label(InventoryCountLineStatus status) {
    return switch (status) {
      InventoryCountLineStatus.sinContar => 'Sin contar',
      InventoryCountLineStatus.contado => 'Contado',
      InventoryCountLineStatus.diferencias => 'Diferencias',
    };
  }

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
                    style: theme.textTheme.titleSmall,
                  ),
                ),
                Chip(
                  key: Key('inventory_line_status_$productId'),
                  label: Text(_label(resolution.status)),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            Text(
              'Stock sistema: $systemStock',
              key: Key('inventory_close_system_$productId'),
            ),
            Text(
              'Vendidos en turno: $unitsSoldInShift',
              key: Key('inventory_close_sold_$productId'),
            ),
            if (resolution.status == InventoryCountLineStatus.diferencias &&
                resolution.delta != null) ...[
              const SizedBox(height: 4),
              Text(
                'Diferencia: ${resolution.delta! > 0 ? '+' : ''}${resolution.delta}',
                key: Key('inventory_line_delta_$productId'),
                style: theme.textTheme.titleMedium?.copyWith(color: cs.error),
              ),
            ],
            if (countField != null) ...[
              const SizedBox(height: 8),
              countField!,
            ] else if (countedQty != null) ...[
              const SizedBox(height: 4),
              Text('Cantidad contada: $countedQty'),
            ],
          ],
        ),
      ),
    );
  }
}