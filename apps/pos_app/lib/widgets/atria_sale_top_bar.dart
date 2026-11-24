import 'package:core/domain/domain.dart';
import 'package:flutter/material.dart';

import '../di/pos_composition.dart';
import '../menu/pos_menu_ui.dart';
import '../screens/product_create_screen.dart';
import '../screens/shift_sales_screen.dart';
import 'sale_operation_menu.dart';

class AtriaSaleTopBar extends StatelessWidget {
  const AtriaSaleTopBar({
    super.key,
    required this.composition,
    required this.visibleEntries,
    this.scannerAction,
  });

  final PosComposition composition;
  final List<PosMenuEntry> visibleEntries;
  final Widget? scannerAction;

  void _open(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    final entries = visibleEntries.toSet();
    final showShiftSales = entries.contains(PosMenuEntry.shiftSales);
    final showProducts = entries.contains(PosMenuEntry.productCreate);

    final menu = SaleOperationMenu(
      composition: composition,
      visibleEntries: visibleEntries,
      menuAnchor: Builder(
        builder: (context) {
          final cs = Theme.of(context).colorScheme;
          return Material(
            color: cs.primary,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.menu, size: 18, color: cs.onPrimary),
                  const SizedBox(width: 6),
                  Text('Menú', style: TextStyle(color: cs.onPrimary)),
                ],
              ),
            ),
          );
        },
      ),
    );

    final hasBarContent =
        visibleEntries.isNotEmpty || showShiftSales || showProducts;

    if (!hasBarContent && scannerAction == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            if (visibleEntries.isNotEmpty) menu,
            if (visibleEntries.isNotEmpty && (showShiftSales || scannerAction != null))
              const SizedBox(width: 8),
            if (showShiftSales)
              OutlinedButton(
                key: const Key('sale_top_shift_sales'),
                onPressed: () => _open(
                  context,
                  ShiftSalesScreen(composition: composition),
                ),
                child: const Text('Ventas turno'),
              ),
            if (scannerAction != null) ...[
              const SizedBox(width: 8),
              scannerAction!,
            ],
            if (showProducts) ...[
              const SizedBox(width: 8),
              FilledButton.icon(
                key: const Key('sale_top_products'),
                onPressed: () => _open(
                  context,
                  ProductCreateScreen(composition: composition),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
                icon: const Icon(Icons.inventory_2_outlined),
                label: const Text('PRODUCTOS'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}