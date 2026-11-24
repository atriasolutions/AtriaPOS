import 'product_id.dart';

class ProductSalesRank {
  const ProductSalesRank({
    required this.productId,
    required this.unitsSold,
  });

  final ProductId productId;
  final int unitsSold;
}