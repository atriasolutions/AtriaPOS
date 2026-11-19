import '../domain/domain.dart';
import 'ports/product_repository.dart';

class InMemoryProductRepository implements ProductRepository {
  final _byId = <ProductId, Product>{};

  @override
  Future<void> save(Product product) async {
    _byId[product.id] = product;
  }

  @override
  Future<Product?> findById(StoreId storeId, ProductId id) async {
    final p = _byId[id];
    if (p == null || p.storeId != storeId) return null;
    return p;
  }

  @override
  Future<Product?> findByBarcode(StoreId storeId, String barcode) async {
    for (final p in _byId.values) {
      if (p.storeId == storeId && p.barcode == barcode) return p;
    }
    return null;
  }

  @override
  Future<List<Product>> search(StoreId storeId, String query) async {
    final q = query.trim();
    if (q.isEmpty) return [];

    final byBarcode = await findByBarcode(storeId, q);
    if (byBarcode != null) return [byBarcode];

    for (final p in _byId.values) {
      if (p.storeId == storeId && p.qrPayload == q) return [p];
    }
    final productId = parseProductIdFromScan(q);
    if (productId != null) {
      final byId = await findById(storeId, productId);
      if (byId != null) return [byId];
    }

    final lower = q.toLowerCase();
    final matches = _byId.values
        .where(
          (p) => p.storeId == storeId && p.name.toLowerCase().contains(lower),
        )
        .toList();
    matches.sort((a, b) => a.name.compareTo(b.name));
    return matches;
  }
}