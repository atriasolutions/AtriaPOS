import 'permission.dart';
import 'pos_feature.dart';

enum PosMenuEntry {
  shiftSales(
    feature: PosFeature.shiftSalesList,
    permission: Permission.listarVentasTurno,
  ),
  productExchange(
    feature: PosFeature.shiftSalesList,
    permission: Permission.cambiarProducto,
  ),
  closeShift(
    feature: PosFeature.closeShift,
    permission: Permission.cerrarCaja,
  ),
  dteQueue(
    feature: PosFeature.dteQueue,
    permission: Permission.consultarCertificado,
  ),
  fiscalCertificate(
    feature: PosFeature.fiscalCertificate,
    permission: Permission.consultarCertificado,
  ),
  dailySales(
    feature: PosFeature.dailySalesReport,
    permission: Permission.consultarReportes,
  ),
  auditTrail(
    feature: PosFeature.auditTrail,
    permission: Permission.consultarAuditoria,
  ),
  stockAdjust(
    feature: PosFeature.stockAdjust,
    permission: Permission.ajustarInventario,
  ),
  stockReceipt(
    feature: PosFeature.stockReceiptGuiaLote,
    permission: Permission.ajustarInventario,
  ),
  inventoryClose(
    feature: PosFeature.inventoryClose,
    permission: Permission.ajustarInventario,
  ),
  stockInsights(
    feature: PosFeature.stockInsights,
    permission: Permission.consultarReportes,
  ),
  productCreate(
    feature: PosFeature.productCreate,
    permission: Permission.configurarCatalogo,
  ),
  userManagement(
    feature: PosFeature.userManagement,
    permission: Permission.gestionarUsuarios,
  ),
  storeConfig(
    feature: PosFeature.storeOperationalConfig,
    permission: Permission.gestionarConfigTienda,
  ),
  ;

  const PosMenuEntry({
    required this.feature,
    required this.permission,
  });

  final PosFeature feature;
  final Permission permission;
}