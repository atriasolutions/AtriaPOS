import 'failures.dart';
import 'product_id.dart';
import 'store_id.dart';

/// Producto de catálogo (DEC-007 IVA incluido, DEC-008 enteros CLP, DEC-009 sin pesables).
class Product {
  Product({
    required this.id,
    required this.storeId,
    required this.name,
    required this.salePriceClp,
    required this.stock,
    this.barcode,
    this.costClp,
    this.blockWhenOutOfStock = true,
  });

  final ProductId id;
  final StoreId storeId;
  final String name;
  final int salePriceClp;
  final int? costClp;
  final String? barcode;
  final int stock;
  final bool blockWhenOutOfStock;

  static Product create({
    required ProductId id,
    required StoreId storeId,
    required String name,
    required int salePriceClp,
    required int initialStock,
    String? barcode,
    int? costClp,
    bool blockWhenOutOfStock = true,
  }) {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      throw const ValidationFailure('El nombre del producto es obligatorio');
    }
    if (salePriceClp <= 0) {
      throw const ValidationFailure('El precio de venta debe ser mayor a 0');
    }
    if (initialStock < 0) {
      throw const ValidationFailure('El stock inicial no puede ser negativo');
    }
    if (costClp != null && costClp < 0) {
      throw const ValidationFailure('El costo no puede ser negativo');
    }

    return Product(
      id: id,
      storeId: storeId,
      name: trimmedName,
      salePriceClp: salePriceClp,
      stock: initialStock,
      barcode: barcode?.trim().isEmpty == true ? null : barcode?.trim(),
      costClp: costClp,
      blockWhenOutOfStock: blockWhenOutOfStock,
    );
  }

  /// Stock actualizado; rechaza cantidad negativa (RF-021).
  Product withStock(int newStock) {
    if (newStock < 0) {
      throw const ValidationFailure(
        'El stock no puede quedar negativo',
      );
    }
    return Product(
      id: id,
      storeId: storeId,
      name: name,
      salePriceClp: salePriceClp,
      stock: newStock,
      barcode: barcode,
      costClp: costClp,
      blockWhenOutOfStock: blockWhenOutOfStock,
    );
  }

  Product applyStockDelta(int delta) => withStock(stock + delta);
}