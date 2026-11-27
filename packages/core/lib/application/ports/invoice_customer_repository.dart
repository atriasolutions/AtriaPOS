import '../../domain/domain.dart';

abstract class InvoiceCustomerRepository {
  Future<SaleInvoiceReceiver?> findByRut(StoreId storeId, String rut);

  Future<void> save(StoreId storeId, SaleInvoiceReceiver receiver);
}
