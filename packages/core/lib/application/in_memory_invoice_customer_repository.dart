import '../domain/domain.dart';
import 'ports/invoice_customer_repository.dart';

class InMemoryInvoiceCustomerRepository implements InvoiceCustomerRepository {
  final _byKey = <String, SaleInvoiceReceiver>{};

  @override
  Future<SaleInvoiceReceiver?> findByRut(StoreId storeId, String rut) async {
    return _byKey['$storeId|$rut'];
  }

  @override
  Future<void> save(StoreId storeId, SaleInvoiceReceiver receiver) async {
    _byKey['$storeId|${receiver.rut}'] = receiver;
  }
}
