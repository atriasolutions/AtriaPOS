import '../domain/domain.dart';
import 'auth_helpers.dart';
import 'ports/product_repository.dart';
import 'ports/sale_repository.dart';
import 'ports/session_provider.dart';
import 'ports/shift_repository.dart';

class InventoryClosePreviewItem {
  const InventoryClosePreviewItem({
    required this.productId,
    required this.name,
    required this.systemStock,
    required this.unitsSoldInShift,
  });

  final ProductId productId;
  final String name;
  final int systemStock;
  final int unitsSoldInShift;
}

class InventoryClosePreview {
  const InventoryClosePreview({
    required this.shiftId,
    required this.items,
  });

  final ShiftId shiftId;
  final List<InventoryClosePreviewItem> items;
}

class GetInventoryClosePreview {
  GetInventoryClosePreview(
    this._shifts,
    this._products,
    this._sales,
    this._sessions,
  );

  final ShiftRepository _shifts;
  final ProductRepository _products;
  final SaleRepository _sales;
  final SessionProvider _sessions;

  Future<InventoryClosePreview> call(StoreId storeId) async {
    AuthPolicy.require(
      requireActiveSession(_sessions),
      Permission.ajustarInventario,
    );

    final shift = await _shifts.findOpenByStore(storeId);
    if (shift == null) {
      throw const NotFoundFailure('No hay turno abierto');
    }

    final sales = await _sales.listByShift(storeId, shift.id);
    final units = unitsSoldByProductInShift(sales);
    final products = await _products.listByStore(storeId);

    final items = [
      for (final product in products)
        InventoryClosePreviewItem(
          productId: product.id,
          name: product.name,
          systemStock: product.stock,
          unitsSoldInShift: units[product.id] ?? 0,
        ),
    ];

    return InventoryClosePreview(shiftId: shift.id, items: items);
  }
}