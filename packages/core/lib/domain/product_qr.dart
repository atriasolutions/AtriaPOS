import 'product_id.dart';
import 'store_id.dart';

String buildProductQrPayload(StoreId storeId, ProductId productId) =>
    'https://pos.barrio/v1/p?sid=$storeId&pid=$productId';

/// Resuelve productId desde payload o texto escaneado.
String? parseProductIdFromScan(String raw) {
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return null;
  final uri = Uri.tryParse(trimmed);
  if (uri != null && uri.queryParameters.containsKey('pid')) {
    return uri.queryParameters['pid'];
  }
  return null;
}