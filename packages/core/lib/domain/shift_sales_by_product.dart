import 'product_id.dart';
import 'sale.dart';
import 'shift_cash_math.dart';

/// Unidades vendidas por producto en ventas del turno (excluye anuladas).
Map<ProductId, int> unitsSoldByProductInShift(List<Sale> sales) {
  final units = <String, int>{};
  for (final sale in sales) {
    if (!saleCountsForShiftTotals(sale)) continue;
    for (final line in sale.lines) {
      units.update(
        line.productId,
        (v) => v + line.quantity,
        ifAbsent: () => line.quantity,
      );
    }
  }
  return units;
}