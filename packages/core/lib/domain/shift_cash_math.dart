import 'payment_method.dart';
import 'sale.dart';

int shiftSalesTotalClp(List<Sale> sales) {
  return sales.fold<int>(0, (sum, sale) => sum + sale.totalClp);
}

int shiftExpectedCashClp(int openingCashClp, List<Sale> sales) {
  var cash = openingCashClp;
  for (final sale in sales) {
    final hasCash =
        sale.payments.any((p) => p.method == PaymentMethod.efectivo);
    if (!hasCash) continue;
    final cashIn = sale.payments
        .where((p) => p.method == PaymentMethod.efectivo)
        .fold<int>(0, (sum, p) => sum + p.amountClp);
    cash += cashIn - sale.changeClp;
  }
  return cash;
}