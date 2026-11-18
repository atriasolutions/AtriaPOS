import '../domain/domain.dart';
import 'ports/product_repository.dart';

class SearchProducts {
  SearchProducts(this._repository);

  final ProductRepository _repository;

  Future<List<Product>> call(StoreId storeId, String query) {
    return _repository.search(storeId, query);
  }
}