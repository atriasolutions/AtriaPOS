import 'package:core/pos_barrio_core.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'src/database.dart';

const _uuid = Uuid();

class DriftSaleRepository implements SaleRepository {
  DriftSaleRepository(this._db);

  final AppDatabase _db;

  @override
  Future<void> save(Sale sale) async {
    final existing = await findById(sale.storeId, sale.id);
    if (existing != null) {
      await (_db.update(_db.sales)..where((t) => t.id.equals(sale.id))).write(
        SalesCompanion(
          dteStatus: Value(sale.dteStatus.apiValue),
          folio: Value(sale.folio),
          pdfUrl: Value(sale.pdfUrl),
        ),
      );
      return;
    }

    await _db.transaction(() async {
      await _db.into(_db.sales).insert(
            SalesCompanion.insert(
              id: sale.id,
              storeId: sale.storeId,
              shiftId: sale.shiftId,
              cartId: sale.cartId,
              totalClp: sale.totalClp,
              changeClp: sale.changeClp,
              createdAt: sale.createdAt.toUtc().toIso8601String(),
              dteStatus: Value(sale.dteStatus.apiValue),
              folio: Value(sale.folio),
              pdfUrl: Value(sale.pdfUrl),
            ),
          );
      for (final line in sale.lines) {
        await _db.into(_db.saleLines).insert(
              SaleLinesCompanion.insert(
                id: _uuid.v4(),
                saleId: sale.id,
                productId: line.productId,
                productName: line.productName,
                quantity: line.quantity,
                unitPriceClp: line.unitPriceClp,
              ),
            );
      }
      for (final payment in sale.payments) {
        await _db.into(_db.payments).insert(
              PaymentsCompanion.insert(
                id: _uuid.v4(),
                saleId: sale.id,
                method: payment.method.apiValue,
                amountClp: payment.amountClp,
              ),
            );
      }
    });
  }

  @override
  Future<Sale?> findById(StoreId storeId, SaleId saleId) async {
    final row = await (_db.select(_db.sales)
          ..where((t) => t.id.equals(saleId) & t.storeId.equals(storeId)))
        .getSingleOrNull();
    if (row == null) return null;

    final lineRows = await (_db.select(_db.saleLines)
          ..where((t) => t.saleId.equals(saleId)))
        .get();
    final paymentRows = await (_db.select(_db.payments)
          ..where((t) => t.saleId.equals(saleId)))
        .get();

    return _mapSale(row, lineRows, paymentRows);
  }

  @override
  Future<List<Sale>> listByShift(StoreId storeId, ShiftId shiftId) async {
    final rows = await (_db.select(_db.sales)
          ..where(
            (t) => t.storeId.equals(storeId) & t.shiftId.equals(shiftId),
          ))
        .get();
    final sales = <Sale>[];
    for (final row in rows) {
      final lineRows = await (_db.select(_db.saleLines)
            ..where((t) => t.saleId.equals(row.id)))
          .get();
      final paymentRows = await (_db.select(_db.payments)
            ..where((t) => t.saleId.equals(row.id)))
          .get();
      sales.add(_mapSale(row, lineRows, paymentRows));
    }
    return sales;
  }

  Sale _mapSale(
    SaleRow row,
    List<SaleLineRow> lineRows,
    List<PaymentRow> paymentRows,
  ) =>
      Sale(
        id: row.id,
        storeId: row.storeId,
        shiftId: row.shiftId,
        cartId: row.cartId,
        lines: lineRows
            .map(
              (l) => SaleLine(
                productId: l.productId,
                productName: l.productName,
                quantity: l.quantity,
                unitPriceClp: l.unitPriceClp,
              ),
            )
            .toList(),
        payments: paymentRows
            .map(
              (p) => Payment(
                method: PaymentMethod.fromApi(p.method),
                amountClp: p.amountClp,
              ),
            )
            .toList(),
        totalClp: row.totalClp,
        changeClp: row.changeClp,
        createdAt: DateTime.parse(row.createdAt).toUtc(),
        dteStatus: DteStatus.fromApi(row.dteStatus),
        folio: row.folio,
        pdfUrl: row.pdfUrl,
      );
}