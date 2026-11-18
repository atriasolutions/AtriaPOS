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
}