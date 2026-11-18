import 'failures.dart';
import 'cart_line_id.dart';
import 'product_id.dart';

class CartLine {
  CartLine({
    required this.lineId,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPriceClp,
  });

  final CartLineId lineId;
  final ProductId productId;
  final String productName;
  final int quantity;
  final int unitPriceClp;

  int get lineTotalClp => quantity * unitPriceClp;

  CartLine withQuantity(int newQuantity) {
    if (newQuantity <= 0) {
      throw const ValidationFailure('La cantidad debe ser mayor a 0');
    }
    return CartLine(
      lineId: lineId,
      productId: productId,
      productName: productName,
      quantity: newQuantity,
      unitPriceClp: unitPriceClp,
    );
  }

  static CartLine create({
    required ProductId productId,
    required String productName,
    required int quantity,
    required int unitPriceClp,
  }) {
    if (quantity <= 0) {
      throw const ValidationFailure('La cantidad debe ser mayor a 0');
    }
    return CartLine(
      lineId: newCartLineId(),
      productId: productId,
      productName: productName,
      quantity: quantity,
      unitPriceClp: unitPriceClp,
    );
  }
}