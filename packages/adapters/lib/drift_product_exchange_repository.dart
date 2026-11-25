import 'package:core/atria_pos_core.dart';
import 'package:drift/drift.dart';

import 'src/database.dart';

class DriftProductExchangeRepository implements ProductExchangeRepository {
  DriftProductExchangeRepository(this._db);

  final AppDatabase _db;

  @override
  Future<void> save(ProductExchange exchange) async {
    await _db.into(_db.productExchanges).insertOnConflictUpdate(
          ProductExchangesCompanion.insert(
            id: exchange.id,
            storeId: exchange.storeId,
            shiftId: exchange.shiftId,
            originalSaleId: exchange.originalSaleId,
            returnProductId: exchange.returnProductId,
            returnQuantity: exchange.returnQuantity,
            originalUnitPriceClp: exchange.originalUnitPriceClp,
            newProductId: exchange.newProductId,
            newQuantity: exchange.newQuantity,
            newUnitPriceClp: exchange.newUnitPriceClp,
            creditClp: exchange.creditClp,
            chargeClp: exchange.chargeClp,
            differenceClp: exchange.differenceClp,
            newSaleId: exchange.newSaleId,
            createdAt: exchange.createdAt.toUtc().toIso8601String(),
            actorUserId: exchange.actorUserId,
            differencePaymentMethod: Value(exchange.differencePaymentMethod?.apiValue),
            differencePaymentAmountClp:
                Value(exchange.differencePaymentAmountClp),
            creditNoteId: Value(exchange.creditNoteId),
          ),
        );
  }

  @override
  Future<List<ProductExchange>> listBySale(
    StoreId storeId,
    SaleId saleId,
  ) async {
    final rows = await (_db.select(_db.productExchanges)
          ..where(
            (t) =>
                t.storeId.equals(storeId) & t.originalSaleId.equals(saleId),
          ))
        .get();
    return rows.map(_map).toList();
  }

  @override
  Future<int> sumReturnedQty(
    StoreId storeId,
    SaleId saleId,
    ProductId productId,
  ) async {
    final rows = await (_db.select(_db.productExchanges)
          ..where(
            (t) =>
                t.storeId.equals(storeId) &
                t.originalSaleId.equals(saleId) &
                t.returnProductId.equals(productId),
          ))
        .get();
    return rows.fold<int>(0, (sum, r) => sum + r.returnQuantity);
  }

  ProductExchange _map(ProductExchangeRow row) {
    PaymentMethod? method;
    final methodRaw = row.differencePaymentMethod;
    if (methodRaw != null && methodRaw.isNotEmpty) {
      method = PaymentMethod.fromApi(methodRaw);
    }
    return ProductExchange(
      id: row.id,
      storeId: row.storeId,
      shiftId: row.shiftId,
      originalSaleId: row.originalSaleId,
      returnProductId: row.returnProductId,
      returnQuantity: row.returnQuantity,
      originalUnitPriceClp: row.originalUnitPriceClp,
      newProductId: row.newProductId,
      newQuantity: row.newQuantity,
      newUnitPriceClp: row.newUnitPriceClp,
      creditClp: row.creditClp,
      chargeClp: row.chargeClp,
      differenceClp: row.differenceClp,
      newSaleId: row.newSaleId,
      createdAt: DateTime.parse(row.createdAt).toUtc(),
      actorUserId: row.actorUserId,
      differencePaymentMethod: method,
      differencePaymentAmountClp: row.differencePaymentAmountClp,
      creditNoteId: row.creditNoteId,
    );
  }
}