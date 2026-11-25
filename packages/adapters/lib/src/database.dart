import 'package:drift/drift.dart';

part 'database.g.dart';

@DataClassName('StoreRow')
class Stores extends Table {
  TextColumn get id => text()();
  TextColumn get rut => text()();
  TextColumn get legalName => text()();
  TextColumn get businessLine => text()();
  TextColumn get taxConfig => text()();
  TextColumn get createdAt => text()();
  TextColumn get posTemplateId => text().withDefault(const Constant('ATRIA_POS'))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('ProductRow')
class Products extends Table {
  TextColumn get id => text()();
  TextColumn get storeId => text()();
  TextColumn get name => text()();
  IntColumn get salePriceClp => integer()();
  IntColumn get costClp => integer().nullable()();
  TextColumn get barcode => text().nullable()();
  TextColumn get qrPayload => text().nullable()();
  IntColumn get stock => integer()();
  BoolColumn get blockWhenOutOfStock => boolean()();
  IntColumn get lowStockThreshold =>
      integer().named('low_stock_threshold').nullable()();

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
  TextColumn get guideRef => text().named('guide_ref').nullable()();
  TextColumn get lotRef => text().named('lot_ref').nullable()();

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
  TextColumn get status => text().withDefault(const Constant('CONFIRMADA'))();
  TextColumn get dteStatus =>
      text().withDefault(const Constant('PENDIENTE_DTE'))();
  IntColumn get folio => integer().nullable()();
  TextColumn get pdfUrl => text().nullable()();
  TextColumn get confirmedByUserId => text().nullable()();
  TextColumn get sellerCode => text().named('seller_code').nullable()();
  TextColumn get voidedAt => text().named('voided_at').nullable()();
  TextColumn get voidedByUserId =>
      text().named('voided_by_user_id').nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('DteQueueRow')
class DteQueue extends Table {
  TextColumn get documentId => text().named('document_id')();
  TextColumn get saleId => text().named('sale_id')();
  TextColumn get storeId => text()();
  IntColumn get documentType =>
      integer().named('document_type').withDefault(const Constant(39))();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  TextColumn get createdAt => text()();

  @override
  Set<Column<Object>> get primaryKey => {documentId};
}

@DataClassName('CreditNoteRow')
class CreditNotes extends Table {
  TextColumn get id => text()();
  TextColumn get storeId => text().named('store_id')();
  TextColumn get saleId => text().named('sale_id')();
  IntColumn get totalClp => integer().named('total_clp')();
  TextColumn get dteStatus => text().named('dte_status')();
  IntColumn get folio => integer().nullable()();
  TextColumn get pdfUrl => text().named('pdf_url').nullable()();
  TextColumn get createdAt => text().named('created_at')();
  TextColumn get actorUserId => text().named('actor_user_id')();
  IntColumn get referencedSaleFolio => integer().named('referenced_sale_folio')();
  IntColumn get referencedDocumentType =>
      integer().named('referenced_document_type')();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('CreditNoteLineRow')
class CreditNoteLines extends Table {
  TextColumn get id => text()();
  TextColumn get creditNoteId => text().named('credit_note_id')();
  TextColumn get productId => text().named('product_id')();
  TextColumn get productName => text().named('product_name')();
  IntColumn get quantity => integer()();
  IntColumn get unitPriceClp => integer().named('unit_price_clp')();

  @override
  Set<Column<Object>> get primaryKey => {id};
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

@DataClassName('ProductExchangeRow')
class ProductExchanges extends Table {
  TextColumn get id => text()();
  TextColumn get storeId => text().named('store_id')();
  TextColumn get shiftId => text().named('shift_id')();
  TextColumn get originalSaleId => text().named('original_sale_id')();
  TextColumn get returnProductId => text().named('return_product_id')();
  IntColumn get returnQuantity => integer().named('return_quantity')();
  IntColumn get originalUnitPriceClp => integer().named('original_unit_price_clp')();
  TextColumn get newProductId => text().named('new_product_id')();
  IntColumn get newQuantity => integer().named('new_quantity')();
  IntColumn get newUnitPriceClp => integer().named('new_unit_price_clp')();
  IntColumn get creditClp => integer().named('credit_clp')();
  IntColumn get chargeClp => integer().named('charge_clp')();
  IntColumn get differenceClp => integer().named('difference_clp')();
  TextColumn get newSaleId => text().named('new_sale_id')();
  TextColumn get createdAt => text().named('created_at')();
  TextColumn get actorUserId => text().named('actor_user_id')();
  TextColumn get differencePaymentMethod =>
      text().named('difference_payment_method').nullable()();
  IntColumn get differencePaymentAmountClp =>
      integer().named('difference_payment_amount_clp').nullable()();
  TextColumn get creditNoteId => text().named('credit_note_id').nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('InventoryCloseRow')
class InventoryCloses extends Table {
  TextColumn get id => text()();
  TextColumn get storeId => text().named('store_id')();
  TextColumn get shiftId => text().named('shift_id')();
  TextColumn get createdAt => text().named('created_at')();
  TextColumn get actorUserId => text().named('actor_user_id')();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('InventoryCloseLineRow')
class InventoryCloseLines extends Table {
  TextColumn get id => text()();
  TextColumn get closeId => text().named('close_id')();
  TextColumn get productId => text().named('product_id')();
  IntColumn get systemStock => integer().named('system_stock')();
  IntColumn get countedStock => integer().named('counted_stock')();
  IntColumn get variance => integer()();
  IntColumn get unitsSoldInShift =>
      integer().named('units_sold_in_shift')();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('CollaboratorRow')
class Collaborators extends Table {
  TextColumn get id => text()();
  TextColumn get storeId => text()();
  TextColumn get sellerCode => text().named('seller_code')();
  TextColumn get firstName => text().named('first_name')();
  TextColumn get lastName => text().named('last_name')();
  BoolColumn get active => boolean().withDefault(const Constant(true))();

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
  TextColumn get username => text()();
  TextColumn get firstName => text().named('first_name')();
  TextColumn get lastName => text().named('last_name')();
  TextColumn get userRut => text().named('user_rut')();
  TextColumn get createdAt => text().named('created_at')();
  TextColumn get createdByUserId =>
      text().named('created_by_user_id').nullable()();

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

@DataClassName('ClockStateRow')
class ClockState extends Table {
  TextColumn get id => text()();
  IntColumn get offsetMicroseconds => integer().withDefault(const Constant(0))();
  TextColumn get lastSyncAt => text().nullable()();
  TextColumn get source => text().withDefault(const Constant('device'))();
  BoolColumn get degraded => boolean().withDefault(const Constant(true))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('DteFolioCounterRow')
class DteFolioCounters extends Table {
  TextColumn get storeId => text()();
  IntColumn get documentType => integer()();
  IntColumn get nextFolio => integer()();
  IntColumn get cafDesde => integer()();
  IntColumn get cafHasta => integer()();

  @override
  Set<Column<Object>> get primaryKey => {storeId, documentType};
}

@DriftDatabase(tables: [
  Stores,
  Products,
  StockMovements,
  Shifts,
  Sales,
  SaleLines,
  Payments,
  DteQueue,
  Users,
  Collaborators,
  InventoryCloses,
  InventoryCloseLines,
  ProductExchanges,
  CreditNotes,
  CreditNoteLines,
  DteFolioCounters,
  ClockState,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 22;

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
          await customStatement(
            'CREATE UNIQUE INDEX idx_collaborators_store_code_active '
            'ON collaborators (store_id, seller_code) WHERE active = 1',
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
          if (from < 7) {
            await m.createTable(dteFolioCounters);
          }
          if (from < 8) {
            await m.addColumn(sales, sales.status);
          }
          if (from < 9) {
            await m.createTable(stores);
            await customStatement('''
INSERT INTO stores (id, rut, legal_name, business_line, tax_config, created_at)
SELECT 'tienda_demo', '00.000.000-0', 'Tienda demo', 'Comercio',
  '{"defaultTaxTreatment":"AFECTO"}', datetime('now')
WHERE (
  EXISTS (SELECT 1 FROM products WHERE store_id = 'tienda_demo')
  OR EXISTS (SELECT 1 FROM users WHERE store_id = 'tienda_demo')
) AND NOT EXISTS (SELECT 1 FROM stores);
''');
          }
          if (from < 10) {
            await m.createTable(clockState);
            await customStatement(
              "INSERT INTO clock_state (id, offset_microseconds, source, degraded) "
              "VALUES ('default', 0, 'device', 1)",
            );
          }
          if (from < 11) {
            await m.addColumn(products, products.qrPayload);
          }
          if (from < 12) {
            await m.addColumn(sales, sales.confirmedByUserId);
          }
          if (from < 13) {
            await m.addColumn(users, users.username);
            await m.addColumn(users, users.firstName);
            await m.addColumn(users, users.lastName);
            await m.addColumn(users, users.userRut);
            await customStatement(
              "UPDATE users SET username = id, "
              "first_name = display_name, last_name = '', user_rut = '' "
              'WHERE username IS NULL',
            );
            await customStatement(
              'CREATE UNIQUE INDEX IF NOT EXISTS idx_users_store_username '
              'ON users (store_id, username)',
            );
          }
          if (from < 14) {
            await m.createTable(collaborators);
            await customStatement(
              'CREATE UNIQUE INDEX idx_collaborators_store_code_active '
              'ON collaborators (store_id, seller_code) WHERE active = 1',
            );
          }
          if (from < 15) {
            await m.addColumn(sales, sales.sellerCode);
          }
          if (from < 16) {
            await m.addColumn(stockMovements, stockMovements.guideRef);
            await m.addColumn(stockMovements, stockMovements.lotRef);
          }
          if (from < 17) {
            await m.addColumn(sales, sales.voidedAt);
            await m.addColumn(sales, sales.voidedByUserId);
            await m.addColumn(users, users.createdAt);
            await m.addColumn(users, users.createdByUserId);
            await customStatement(
              "UPDATE users SET created_at = datetime('now') "
              'WHERE created_at IS NULL',
            );
          }
          if (from < 18) {
            await m.addColumn(products, products.lowStockThreshold);
          }
          if (from < 19) {
            await m.createTable(inventoryCloses);
            await m.createTable(inventoryCloseLines);
          }
          if (from < 20) {
            await m.addColumn(stores, stores.posTemplateId);
            await customStatement(
              "UPDATE stores SET pos_template_id = 'ATRIA_POS' "
              'WHERE pos_template_id IS NULL',
            );
          }
          if (from < 21) {
            await m.createTable(productExchanges);
          }
          if (from < 22) {
            await m.createTable(creditNotes);
            await m.createTable(creditNoteLines);
            await customStatement('''
CREATE TABLE dte_queue_new (
  document_id TEXT NOT NULL PRIMARY KEY,
  sale_id TEXT NOT NULL,
  store_id TEXT NOT NULL,
  document_type INTEGER NOT NULL DEFAULT 39,
  attempts INTEGER NOT NULL DEFAULT 0,
  last_error TEXT,
  created_at TEXT NOT NULL
);
INSERT INTO dte_queue_new (
  document_id, sale_id, store_id, document_type, attempts, last_error, created_at
)
SELECT sale_id, sale_id, store_id, 39, attempts, last_error, created_at FROM dte_queue;
DROP TABLE dte_queue;
ALTER TABLE dte_queue_new RENAME TO dte_queue;
''');
          }
        },
      );
}