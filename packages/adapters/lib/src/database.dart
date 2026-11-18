import 'package:drift/drift.dart';

part 'database.g.dart';

@DataClassName('ProductRow')
class Products extends Table {
  TextColumn get id => text()();
  TextColumn get storeId => text()();
  TextColumn get name => text()();
  IntColumn get salePriceClp => integer()();
  IntColumn get costClp => integer().nullable()();
  TextColumn get barcode => text().nullable()();
  IntColumn get stock => integer()();
  BoolColumn get blockWhenOutOfStock => boolean()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('StockMovementRow')
class StockMovements extends Table {
  TextColumn get id => text()();
  TextColumn get storeId => text()();
  TextColumn get productId => text()();
  IntColumn get delta => integer()();
  TextColumn get reason => text()();
  TextColumn get note => text().nullable()();
  TextColumn get actorId => text().nullable()();
  TextColumn get createdAt => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('ShiftRow')
class Shifts extends Table {
  TextColumn get id => text()();
  TextColumn get storeId => text()();
  IntColumn get openingCashClp => integer()();
  IntColumn get countedCashClp => integer().nullable()();
  TextColumn get status => text()();
  TextColumn get openedAt => text()();
  TextColumn get closedAt => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('SaleRow')
class Sales extends Table {
  TextColumn get id => text()();
  TextColumn get storeId => text()();
  TextColumn get shiftId => text()();
  TextColumn get cartId => text()();
  IntColumn get totalClp => integer()();
  IntColumn get changeClp => integer()();
  TextColumn get createdAt => text()();
  TextColumn get dteStatus =>
      text().withDefault(const Constant('PENDIENTE_DTE'))();
  IntColumn get folio => integer().nullable()();
  TextColumn get pdfUrl => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('DteQueueRow')
class DteQueue extends Table {
  TextColumn get saleId => text()();
  TextColumn get storeId => text()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  TextColumn get createdAt => text()();

  @override
  Set<Column<Object>> get primaryKey => {saleId};
}

@DataClassName('SaleLineRow')
class SaleLines extends Table {
  TextColumn get id => text()();
  TextColumn get saleId => text()();
  TextColumn get productId => text()();
  TextColumn get productName => text()();
  IntColumn get quantity => integer()();
  IntColumn get unitPriceClp => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('UserRow')
class Users extends Table {
  TextColumn get id => text()();
  TextColumn get storeId => text()();
  TextColumn get role => text()();
  TextColumn get pinHash => text()();
  TextColumn get displayName => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('PaymentRow')
class Payments extends Table {
  TextColumn get id => text()();
  TextColumn get saleId => text()();
  TextColumn get method => text()();
  IntColumn get amountClp => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(tables: [
  Products,
  StockMovements,
  Shifts,
  Sales,
  SaleLines,
  Payments,
  DteQueue,
  Users,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await customStatement(
            'CREATE UNIQUE INDEX idx_products_store_barcode '
            'ON products (store_id, barcode) WHERE barcode IS NOT NULL',
          );
          await customStatement(
            'CREATE INDEX idx_products_store_name ON products (store_id, name)',
          );
          await customStatement(
            'CREATE INDEX idx_stock_movements_product '
            'ON stock_movements (store_id, product_id, created_at)',
          );
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(stockMovements);
            await customStatement(
              'CREATE INDEX idx_stock_movements_product '
              'ON stock_movements (store_id, product_id, created_at)',
            );
          }
          if (from < 3) {
            await m.createTable(sales);
            await m.createTable(saleLines);
            await m.createTable(payments);
          }
          if (from < 4) {
            await m.createTable(shifts);
            await m.addColumn(sales, sales.shiftId);
          }
          if (from < 5) {
            await m.addColumn(sales, sales.dteStatus);
            await m.addColumn(sales, sales.folio);
            await m.addColumn(sales, sales.pdfUrl);
            await m.createTable(dteQueue);
          }
          if (from < 6) {
            await m.createTable(users);
          }
        },
      );
}