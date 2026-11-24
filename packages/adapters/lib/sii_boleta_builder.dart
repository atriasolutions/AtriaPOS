import 'package:core/atria_pos_core.dart';

/// Payload mínimo boleta 39 para adaptador SII (Fase A).
class SiiBoletaBuilder {
  Map<String, Object?> build(Sale sale) => {
        'tipoDte': 39,
        'saleId': sale.id,
        'storeId': sale.storeId,
        'totalClp': sale.totalClp,
        'lineCount': sale.lines.length,
        'lines': sale.lines
            .map(
              (l) => {
                'productId': l.productId,
                'name': l.productName,
                'quantity': l.quantity,
                'unitPriceClp': l.unitPriceClp,
              },
            )
            .toList(),
      };
}