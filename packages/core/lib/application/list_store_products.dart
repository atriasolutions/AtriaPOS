import '../domain/domain.dart';
import 'auth_helpers.dart';
import 'ports/product_repository.dart';
import 'ports/session_provider.dart';

class ListStoreProducts {
  ListStoreProducts(this._products, this._sessions);

  final ProductRepository _products;
  final SessionProvider _sessions;

  Future<List<Product>> call(StoreId storeId) async {
    AuthPolicy.require(
      requireActiveSession(_sessions),
      Permission.consultarStock,
    );
    final products = await _products.listByStore(storeId);
    products.sort((a, b) => a.name.compareTo(b.name));
    return products;
  }
}