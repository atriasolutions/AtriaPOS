import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';

import 'src/database.dart';

class DriftInvoiceCustomerRepository implements InvoiceCustomerRepository {
  DriftInvoiceCustomerRepository(this._db);

  final AppDatabase _db;

  @override
  Future<SaleInvoiceReceiver?> findByRut(StoreId storeId, String rut) async {
    final row = await (_db.select(_db.invoiceCustomers)
          ..where((t) => t.storeId.equals(storeId))
          ..where((t) => t.rut.equals(rut)))
        .getSingleOrNull();
    if (row == null) return null;
    return SaleInvoiceReceiver(
      rut: row.rut,
      businessName: row.businessName,
      giro: row.giro,
      email: row.email,
      address: row.address,
      city: row.city,
      commune: row.commune,
      phone: row.phone,
    );
  }

  @override
  Future<void> save(StoreId storeId, SaleInvoiceReceiver receiver) {
    return _db.into(_db.invoiceCustomers).insertOnConflictUpdate(
          InvoiceCustomersCompanion.insert(
            storeId: storeId,
            rut: receiver.rut,
            businessName: receiver.businessName,
            giro: receiver.giro,
            email: receiver.email,
            address: receiver.address,
            city: receiver.city,
            commune: receiver.commune,
            phone: receiver.phone,
          ),
        );
  }
}
