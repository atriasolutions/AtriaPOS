import 'package:core/atria_pos_core.dart';
import 'package:drift/drift.dart';

import 'src/database.dart';

class DriftProductRepository implements ProductRepository {
  DriftProductRepository(this._db);

  final AppDatabase _db;

  @override
  Future<void> save(Product product) async {
    await _db.into(_db.products).insertOnConflictUpdate(
          ProductsCompanion(
            id: Value(product.id),
            storeId: Value(product.storeId),
            name: Value(product.name),
            salePriceClp: Value(product.salePriceClp),
            costClp: Value(product.costClp),
            barcode: Value(product.barcode),
            qrPayload: Value(product.qrPayload),
            stock: Value(product.stock),
            blockWhenOutOfStock: Value(product.blockWhenOutOfStock),
          ),
        );
  }

  @override
  Future<Product?> findById(StoreId storeId, ProductId id) async {
    final row = await (_db.select(_db.products)
          ..where((t) => t.id.equals(id) & t.storeId.equals(storeId)))
        .getSingleOrNull();
    return row == null ? null : _map(row);
  }

  @override
  Future<Product?> findByBarcode(StoreId storeId, String barcode) async {
    final row = await (_db.select(_db.products)
          ..where(
            (t) => t.storeId.equals(storeId) & t.barcode.equals(barcode),
          ))
        .getSingleOrNull();
    return row == null ? null : _map(row);
  }

  @override
  Future<List<Product>> search(StoreId storeId, String query) async {
    final q = query.trim();
    if (q.isEmpty) return [];

    final byBarcode = await findByBarcode(storeId, q);
    if (byBarcode != null) return [byBarcode];

    final byQr = await (_db.select(_db.products)
          ..where((t) => t.storeId.equals(storeId) & t.qrPayload.equals(q)))
        .getSingleOrNull();
    if (byQr != null) return [_map(byQr)];

    final productId = parseProductIdFromScan(q);
    if (productId != null) {
      final byId = await findById(storeId, productId);
      if (byId != null) return [byId];
    }

    final lower = q.toLowerCase();
    final rows = await (_db.select(_db.products)
          ..where((t) => t.storeId.equals(storeId))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
    return rows
        .where((r) => r.name.toLowerCase().contains(lower))
        .map(_map)
        .toList();
  }

  Product _map(ProductRow row) => Product(
        id: row.id,
        storeId: row.storeId,
        name: row.name,
        salePriceClp: row.salePriceClp,
        costClp: row.costClp,
        barcode: row.barcode,
        qrPayload: row.qrPayload,
        stock: row.stock,
        blockWhenOutOfStock: row.blockWhenOutOfStock,
      );
}