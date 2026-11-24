import 'package:flutter/material.dart';

import '../di/pos_composition.dart';
import '../screens/product_create_screen.dart';
import '../screens/shift_sales_screen.dart';
import 'sale_operation_menu.dart';

class AtriaSaleTopBar extends StatelessWidget {
  const AtriaSaleTopBar({
    super.key,
    required this.composition,
    required this.canVoidSales,
    required this.canCloseShift,
    required this.canAdjustStock,
    required this.canDteQueue,
    required this.canDailyReport,
    required this.canCreateProduct,
    required this.canManageUsers,
    this.scannerAction,
  });

  final PosComposition composition;
  final bool canVoidSales;
  final bool canCloseShift;
  final bool canAdjustStock;
  final bool canDteQueue;
  final bool canDailyReport;
  final bool canCreateProduct;
  final bool canManageUsers;
  final Widget? scannerAction;

  void _open(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    final menu = SaleOperationMenu(
      composition: composition,
      canVoidSales: canVoidSales,
      canCloseShift: canCloseShift,
      canAdjustStock: canAdjustStock,
      canDteQueue: canDteQueue,
      canDailyReport: canDailyReport,
      canCreateProduct: canCreateProduct,
      canManageUsers: canManageUsers,
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

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            menu,
            const SizedBox(width: 8),
            if (canVoidSales)
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
            if (canCreateProduct) ...[
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