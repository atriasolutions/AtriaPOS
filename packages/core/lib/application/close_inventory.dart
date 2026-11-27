import '../domain/domain.dart';
import 'adjust_stock.dart';
import 'auth_helpers.dart';
import 'ports/inventory_close_repository.dart';
import 'ports/product_repository.dart';
import 'ports/sale_repository.dart';
import 'ports/session_provider.dart';
import 'ports/shift_repository.dart';
import 'ports/trusted_clock.dart';

class CloseInventoryLineInput {
  const CloseInventoryLineInput({
    required this.productId,
    required this.countedQty,
  });

  final ProductId productId;
  final int countedQty;
}

class CloseInventory {
  CloseInventory(
    this._shifts,
    this._products,
    this._sales,
    this._adjustStock,
    this._inventoryCloses,
    this._sessions, [
    TrustedClock? clock,
  ]) : _clock = clock ?? MutableTrustedClock();

  final ShiftRepository _shifts;
  final ProductRepository _products;
  final SaleRepository _sales;
  final AdjustStock _adjustStock;
  final InventoryCloseRepository _inventoryCloses;
  final SessionProvider _sessions;
  final TrustedClock _clock;

  Future<InventoryClose> call(
    StoreId storeId,
    List<CloseInventoryLineInput> lines,
  ) async {
    final session = requireActiveSession(_sessions);
    AuthPolicy.require(session, Permission.ajustarInventario);

    if (lines.isEmpty) {
      throw const ValidationFailure('Debe incluir al menos un producto');
    }

    final seen = <String>{};
    for (final line in lines) {
      if (line.countedQty < 0) {
        throw const ValidationFailure(
          'La cantidad contada no puede ser negativa',
        );
      }
      if (!seen.add(line.productId)) {
        throw const ValidationFailure(
          'No puede repetir el mismo producto en el cierre',
        );
      }
    }

    final catalog = await _products.listByStore(storeId);
    final requiredIds = catalog.map((p) => p.id).toSet();
    final providedIds = lines.map((l) => l.productId).toSet();
    if (!requiredIds.every(providedIds.contains)) {
      throw const ValidationFailure(
        'Complete el conteo de todos los productos',
      );
    }

    final shift = await _shifts.findOpenByStore(storeId);
    if (shift == null) {
      throw const NotFoundFailure('No hay turno abierto');
    }

    final sales = await _sales.listByShift(storeId, shift.id);
    final units = unitsSoldByProductInShift(sales);
    final closeId = newInventoryCloseId();
    final createdAt = _clock.now().toUtc();
    final closeLines = <InventoryCloseLine>[];

    for (final input in lines) {
      final product = await _products.findById(storeId, input.productId);
      if (product == null) {
        throw NotFoundFailure(
          'Producto no encontrado',
          details: {'productId': input.productId},
        );
      }

      final systemStock = product.stock;
      final variance = input.countedQty - systemStock;

      product.applyStockDelta(variance);

      if (variance != 0) {
        await _adjustStock(
          AdjustStockInput(
            storeId: storeId,
            productId: input.productId,
            delta: variance,
            reason: StockAdjustmentReason.correccion,
            note: 'Cierre inventario',
            actorId: session.userId,
          ),
        );
      }

      closeLines.add(
        InventoryCloseLine(
          id: newInventoryCloseLineId(),
          productId: input.productId,
          systemStock: systemStock,
          countedStock: input.countedQty,
          variance: variance,
          unitsSoldInShift: units[input.productId] ?? 0,
        ),
      );
    }

    final close = InventoryClose(
      id: closeId,
      storeId: storeId,
      shiftId: shift.id,
      createdAt: createdAt,
      actorUserId: session.userId,
      lines: closeLines,
    );
    await _inventoryCloses.save(close);
    return close;
  }
}