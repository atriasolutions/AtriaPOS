import '../domain/domain.dart';
import 'ports/sale_repository.dart';

class InMemorySaleRepository implements SaleRepository {
  final _sales = <SaleId, Sale>{};

  @override
  Future<void> save(Sale sale) async {
    _sales[sale.id] = sale;
  }

  @override
  Future<Sale?> findById(StoreId storeId, SaleId saleId) async {
    final sale = _sales[saleId];
    if (sale == null || sale.storeId != storeId) return null;
    return sale;
  }

  @override
  Future<List<Sale>> listByShift(StoreId storeId, ShiftId shiftId) async {
    return _sales.values
        .where((s) => s.storeId == storeId && s.shiftId == shiftId)
        .toList();
  }

  @override
  Future<List<Sale>> listByStoreCreatedBetween(
    StoreId storeId,
    DateTime fromInclusive,
    DateTime toExclusive,
  ) async {
    return _sales.values.where((s) {
      if (s.storeId != storeId) return false;
      final local = s.createdAt.toLocal();
      return !local.isBefore(fromInclusive) && local.isBefore(toExclusive);
    }).toList();
  }

  @override
  Future<List<Sale>> listVoidedInRange(
    StoreId storeId,
    DateTime fromInclusive,
    DateTime toExclusive,
  ) async {
    return _sales.values.where((s) {
      if (s.storeId != storeId || s.voidedAt == null) return false;
      final local = s.voidedAt!.toLocal();
      final from = fromInclusive.toLocal();
      final to = toExclusive.toLocal();
      return !local.isBefore(from) && local.isBefore(to);
    }).toList();
  }

  @override
  Future<List<ProductSalesRank>> topProductsByUnits(
    StoreId storeId,
    DateTime fromInclusive,
    DateTime toExclusive,
    int limit,
  ) async {
    final unitsByProduct = <String, int>{};
    final fromUtc = fromInclusive.toUtc();
    final toUtc = toExclusive.toUtc();
    for (final sale in _sales.values) {
      if (sale.storeId != storeId) continue;
      if (!saleCountsForShiftTotals(sale)) continue;
      final created = sale.createdAt.toUtc();
      if (created.isBefore(fromUtc)) continue;
      if (!created.isBefore(toUtc)) continue;
      for (final line in sale.lines) {
        unitsByProduct.update(
          line.productId,
          (v) => v + line.quantity,
          ifAbsent: () => line.quantity,
        );
      }
    }
    final ranks = unitsByProduct.entries
        .map((e) => ProductSalesRank(productId: e.key, unitsSold: e.value))
        .toList()
      ..sort((a, b) => b.unitsSold.compareTo(a.unitsSold));
    if (ranks.length > limit) {
      return ranks.sublist(0, limit);
    }
    return ranks;
  }
}