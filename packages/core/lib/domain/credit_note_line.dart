import 'product_id.dart';

class CreditNoteLine {
  const CreditNoteLine({
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
}