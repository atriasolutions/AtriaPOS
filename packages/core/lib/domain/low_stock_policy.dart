import 'product.dart';

/// Umbral stock bajo (RF-087 / RF-022).
class LowStockPolicy {
  static const defaultLowStockThreshold = 5;

  static int effectiveThreshold(Product product) =>
      product.lowStockThreshold ?? defaultLowStockThreshold;

  static bool isLowStock(Product product) =>
      product.stock <= effectiveThreshold(product);
}