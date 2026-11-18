import 'cart_line.dart';
import 'product_id.dart';

class SaleLine {
  SaleLine({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPriceClp,
  });

  final ProductId productId;
  final String productName;
  final int quantity;
  final int unitPriceClp;

  int get lineTotalClp => quantity * unitPriceClp;

  factory SaleLine.fromCartLine(CartLine line) => SaleLine(
        productId: line.productId,
        productName: line.productName,
        quantity: line.quantity,
        unitPriceClp: line.unitPriceClp,
      );
}