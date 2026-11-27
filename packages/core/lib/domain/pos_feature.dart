enum PosFeature {
  sellerCodeCheckout('sellerCodeCheckout'),
  collaboratorPlanilla('collaboratorPlanilla'),
  stockReceiptGuiaLote('stockReceiptGuiaLote'),
  auditTrail('auditTrail'),
  stockInsights('stockInsights'),
  inventoryClose('inventoryClose'),
  dteQueue('dteQueue'),
  fiscalCertificate('fiscalCertificate'),
  dailySalesReport('dailySalesReport'),
  shiftSalesList('shiftSalesList'),
  closeShift('closeShift'),
  stockAdjust('stockAdjust'),
  productCreate('productCreate'),
  userManagement('userManagement'),
  invoiceCheckout('invoiceCheckout'),
  cardPaymentCheckout('cardPaymentCheckout'),
  transbankIntegration('transbankIntegration'),
  trackExpiryOnReceipt('trackExpiryOnReceipt'),
  storeOperationalConfig('storeOperationalConfig'),
  ;

  const PosFeature(this.apiValue);

  final String apiValue;

  static PosFeature? fromApi(String value) {
    final trimmed = value.trim();
    for (final f in PosFeature.values) {
      if (f.apiValue == trimmed) return f;
    }
    return null;
  }
}