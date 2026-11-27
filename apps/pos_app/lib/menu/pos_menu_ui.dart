import 'package:core/domain/domain.dart';
import 'package:flutter/material.dart';

import '../di/pos_composition.dart';
import '../screens/audit_trail_screen.dart';
import '../screens/certificate_status_screen.dart';
import '../screens/close_shift_screen.dart';
import '../screens/daily_sales_screen.dart';
import '../screens/dte_queue_screen.dart';
import '../screens/inventory_close_screen.dart';
import '../screens/product_create_screen.dart';
import '../screens/product_exchange_screen.dart';
import '../screens/shift_sales_screen.dart';
import '../screens/stock_adjust_screen.dart';
import '../screens/stock_insights_screen.dart';
import '../screens/stock_receipt_screen.dart';
import '../screens/store_config_screen.dart';
import '../screens/user_list_screen.dart';

/// Orden visual del menú operación (sin duplicar productCreate en popup si va en top bar).
const posMenuDisplayOrder = <PosMenuEntry>[
  PosMenuEntry.shiftSales,
  PosMenuEntry.productExchange,
  PosMenuEntry.closeShift,
  PosMenuEntry.dteQueue,
  PosMenuEntry.fiscalCertificate,
  PosMenuEntry.dailySales,
  PosMenuEntry.auditTrail,
  PosMenuEntry.stockAdjust,
  PosMenuEntry.stockReceipt,
  PosMenuEntry.inventoryClose,
  PosMenuEntry.stockInsights,
  PosMenuEntry.productCreate,
  PosMenuEntry.userManagement,
  PosMenuEntry.storeConfig,
];

List<PosMenuEntry> sortMenuEntries(List<PosMenuEntry> visible) {
  final set = visible.toSet();
  return posMenuDisplayOrder.where(set.contains).toList();
}

/// Misma regla que menú Operación → Nuevo producto (SLICE-84).
bool canCreateProduct(UserRole role, PosTemplateId templateId) {
  return PosMenuPolicy.visibleForTemplateId(role, templateId)
      .contains(PosMenuEntry.productCreate);
}

String popupValueFor(PosMenuEntry entry) {
  return switch (entry) {
    PosMenuEntry.shiftSales => 'sales',
    PosMenuEntry.productExchange => 'product_exchange',
    PosMenuEntry.closeShift => 'close',
    PosMenuEntry.dteQueue => 'dte',
    PosMenuEntry.fiscalCertificate => 'certificate',
    PosMenuEntry.dailySales => 'daily',
    PosMenuEntry.auditTrail => 'audit',
    PosMenuEntry.stockAdjust => 'stock',
    PosMenuEntry.stockReceipt => 'stock_receipt',
    PosMenuEntry.inventoryClose => 'inventory_close',
    PosMenuEntry.stockInsights => 'stock_insights',
    PosMenuEntry.productCreate => 'product',
    PosMenuEntry.userManagement => 'users',
    PosMenuEntry.storeConfig => 'store_config',
  };
}

String menuLabelFor(PosMenuEntry entry) {
  return switch (entry) {
    PosMenuEntry.shiftSales => 'Ventas del turno',
    PosMenuEntry.productExchange => 'Cambio mostrador',
    PosMenuEntry.closeShift => 'Cerrar caja',
    PosMenuEntry.dteQueue => 'Cola DTE',
    PosMenuEntry.fiscalCertificate => 'Certificado SII',
    PosMenuEntry.dailySales => 'Ventas del día',
    PosMenuEntry.auditTrail => 'Auditoría del día',
    PosMenuEntry.stockAdjust => 'Ajuste de stock',
    PosMenuEntry.stockReceipt => 'Ingreso existencias',
    PosMenuEntry.inventoryClose => 'Cierre inventario',
    PosMenuEntry.stockInsights => 'Stock insights',
    PosMenuEntry.productCreate => 'Nuevo producto',
    PosMenuEntry.userManagement => 'Usuarios',
    PosMenuEntry.storeConfig => 'Configuración tienda',
  };
}

Key menuItemKeyFor(PosMenuEntry entry) {
  return switch (entry) {
    PosMenuEntry.shiftSales => const Key('operation_menu_sales'),
    PosMenuEntry.productExchange =>
      const Key('operation_menu_product_exchange'),
    PosMenuEntry.closeShift => const Key('operation_menu_close'),
    PosMenuEntry.dteQueue => const Key('operation_menu_dte'),
    PosMenuEntry.fiscalCertificate => const Key('operation_menu_certificate'),
    PosMenuEntry.dailySales => const Key('operation_menu_daily_report'),
    PosMenuEntry.auditTrail => const Key('operation_menu_audit'),
    PosMenuEntry.stockAdjust => const Key('operation_menu_stock'),
    PosMenuEntry.stockReceipt => const Key('operation_menu_stock_receipt'),
    PosMenuEntry.inventoryClose => const Key('operation_menu_inventory_close'),
    PosMenuEntry.stockInsights => const Key('operation_menu_stock_insights'),
    PosMenuEntry.productCreate => const Key('operation_menu_product'),
    PosMenuEntry.userManagement => const Key('operation_menu_users'),
    PosMenuEntry.storeConfig => const Key('operation_menu_store_config'),
  };
}

Future<void> navigateForMenuEntry(
  BuildContext context,
  PosComposition composition,
  PosMenuEntry entry,
) async {
  final screen = switch (entry) {
    PosMenuEntry.shiftSales => ShiftSalesScreen(composition: composition),
    PosMenuEntry.productExchange =>
      ProductExchangeScreen(composition: composition),
    PosMenuEntry.closeShift => CloseShiftScreen(composition: composition),
    PosMenuEntry.dteQueue => DteQueueScreen(composition: composition),
    PosMenuEntry.fiscalCertificate =>
      CertificateStatusScreen(composition: composition),
    PosMenuEntry.dailySales => DailySalesScreen(composition: composition),
    PosMenuEntry.auditTrail => AuditTrailScreen(composition: composition),
    PosMenuEntry.stockAdjust => StockAdjustScreen(composition: composition),
    PosMenuEntry.stockReceipt => StockReceiptScreen(composition: composition),
    PosMenuEntry.inventoryClose =>
      InventoryCloseScreen(composition: composition),
    PosMenuEntry.stockInsights => StockInsightsScreen(composition: composition),
    PosMenuEntry.productCreate => ProductCreateScreen(composition: composition),
    PosMenuEntry.userManagement => UserListScreen(composition: composition),
    PosMenuEntry.storeConfig => StoreConfigScreen(composition: composition),
  };
  await Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => screen),
  );
}

PopupMenuItem<String> buildPopupMenuItem(PosMenuEntry entry) {
  return PopupMenuItem<String>(
    value: popupValueFor(entry),
    child: Text(
      menuLabelFor(entry),
      key: menuItemKeyFor(entry),
    ),
  );
}