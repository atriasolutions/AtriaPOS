import 'package:flutter/material.dart';

import '../di/pos_composition.dart';
import '../screens/audit_trail_screen.dart';
import '../screens/certificate_status_screen.dart';
import '../screens/close_shift_screen.dart';
import '../screens/daily_sales_screen.dart';
import '../screens/dte_queue_screen.dart';
import '../screens/inventory_close_screen.dart';
import '../screens/product_create_screen.dart';
import '../screens/shift_sales_screen.dart';
import '../screens/stock_adjust_screen.dart';
import '../screens/stock_insights_screen.dart';
import '../screens/stock_receipt_screen.dart';
import '../screens/user_list_screen.dart';

class SaleOperationMenu extends StatelessWidget {
  const SaleOperationMenu({
    super.key,
    required this.composition,
    required this.canVoidSales,
    required this.canCloseShift,
    required this.canAdjustStock,
    required this.canDteQueue,
    required this.canDailyReport,
    required this.canCreateProduct,
    required this.canManageUsers,
    this.menuAnchor,
  });

  final PosComposition composition;
  final bool canVoidSales;
  final bool canCloseShift;
  final bool canAdjustStock;
  final bool canDteQueue;
  final bool canDailyReport;
  final bool canCreateProduct;
  final bool canManageUsers;
  final Widget? menuAnchor;

  bool get hasAnyItem =>
      canVoidSales ||
      canCloseShift ||
      canAdjustStock ||
      canDteQueue ||
      canCreateProduct ||
      canDailyReport ||
      canManageUsers;

  void _open(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!hasAnyItem) return const SizedBox.shrink();

    return PopupMenuButton<String>(
      key: const Key('operation_menu_button'),
      tooltip: 'Operación',
      onSelected: (value) {
        switch (value) {
          case 'sales':
            _open(context, ShiftSalesScreen(composition: composition));
          case 'close':
            _open(context, CloseShiftScreen(composition: composition));
          case 'dte':
            _open(context, DteQueueScreen(composition: composition));
          case 'certificate':
            _open(context, CertificateStatusScreen(composition: composition));
          case 'daily':
            _open(context, DailySalesScreen(composition: composition));
          case 'audit':
            _open(context, AuditTrailScreen(composition: composition));
          case 'stock':
            _open(context, StockAdjustScreen(composition: composition));
          case 'stock_receipt':
            _open(context, StockReceiptScreen(composition: composition));
          case 'stock_insights':
            _open(context, StockInsightsScreen(composition: composition));
          case 'inventory_close':
            _open(context, InventoryCloseScreen(composition: composition));
          case 'product':
            _open(context, ProductCreateScreen(composition: composition));
          case 'users':
            _open(context, UserListScreen(composition: composition));
        }
      },
      itemBuilder: (context) => [
        if (canVoidSales)
          const PopupMenuItem(
            value: 'sales',
            child: Text(
              'Ventas del turno',
              key: Key('operation_menu_sales'),
            ),
          ),
        if (canCloseShift)
          const PopupMenuItem(
            value: 'close',
            child: Text(
              'Cerrar caja',
              key: Key('operation_menu_close'),
            ),
          ),
        if (canDteQueue)
          const PopupMenuItem(
            value: 'dte',
            child: Text(
              'Cola DTE',
              key: Key('operation_menu_dte'),
            ),
          ),
        if (canDteQueue)
          const PopupMenuItem(
            value: 'certificate',
            child: Text(
              'Certificado SII',
              key: Key('operation_menu_certificate'),
            ),
          ),
        if (canDailyReport)
          const PopupMenuItem(
            value: 'daily',
            child: Text(
              'Ventas del día',
              key: Key('operation_menu_daily_report'),
            ),
          ),
        if (canVoidSales)
          const PopupMenuItem(
            value: 'audit',
            child: Text(
              'Auditoría del día',
              key: Key('operation_menu_audit'),
            ),
          ),
        if (canAdjustStock)
          const PopupMenuItem(
            value: 'stock',
            child: Text(
              'Ajuste de stock',
              key: Key('operation_menu_stock'),
            ),
          ),
        if (canAdjustStock)
          const PopupMenuItem(
            value: 'stock_receipt',
            child: Text(
              'Ingreso existencias',
              key: Key('operation_menu_stock_receipt'),
            ),
          ),
        if (canAdjustStock)
          const PopupMenuItem(
            value: 'inventory_close',
            child: Text(
              'Cierre inventario',
              key: Key('operation_menu_inventory_close'),
            ),
          ),
        if (canDailyReport)
          const PopupMenuItem(
            value: 'stock_insights',
            child: Text(
              'Stock insights',
              key: Key('operation_menu_stock_insights'),
            ),
          ),
        if (canCreateProduct)
          const PopupMenuItem(
            value: 'product',
            child: Text(
              'Nuevo producto',
              key: Key('operation_menu_product'),
            ),
          ),
        if (canManageUsers)
          const PopupMenuItem(
            value: 'users',
            child: Text(
              'Usuarios',
              key: Key('operation_menu_users'),
            ),
          ),
      ],
      child: menuAnchor,
    );
  }
}