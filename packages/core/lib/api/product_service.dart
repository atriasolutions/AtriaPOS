import '../application/application.dart';
import '../domain/domain.dart';
import 'api_error.dart';
import 'api_result.dart';
import 'product_dtos.dart';

class ProductService {
  factory ProductService({
    ProductRepository? repository,
    SessionProvider? sessionProvider,
  }) {
    final repo = repository ?? InMemoryProductRepository();
    final sessions =
        sessionProvider ?? InMemorySessionProvider.supervisor();
    return ProductService._(repo, sessions);
  }

  ProductService._(ProductRepository repository, SessionProvider sessions)
      : _repository = repository,
        _sessions = sessions,
        _create = CreateProduct(repository, sessions),
        _search = SearchProducts(repository),
        _list = ListStoreProducts(repository, sessions);

  final ProductRepository _repository;
  final SessionProvider _sessions;
  final CreateProduct _create;
  final SearchProducts _search;
  final ListStoreProducts _list;

  Future<ApiResult<ProductResponse>> createProduct(
    StoreId storeId,
    CreateProductRequest request,
  ) async {
    try {
      final product = await _create(
        CreateProductInput(
          storeId: storeId,
          name: request.name,
          salePriceClp: request.salePriceClp,
          initialStock: request.initialStock,
          barcode: request.barcode,
          costClp: request.costClp,
          blockWhenOutOfStock: request.blockWhenOutOfStock,
        ),
      );
      return ApiSuccess(_toResponse(product), statusCode: 201);
    } on ValidationFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 400,
      );
    } on ConflictFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message, details: e.details),
        statusCode: 409,
      );
    } on CredentialFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 401,
      );
    } on ForbiddenFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 403,
      );
    } on SessionExpiredFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 401,
      );
    }
  }

  Future<ApiResult<SearchProductsResponse>> searchProducts(
    StoreId storeId,
    String query,
  ) async {
    final products = await _search(storeId, query);
    final items = products.map(_toSearchItem).toList();
    return ApiSuccess(SearchProductsResponse(items: items), statusCode: 200);
  }

  Future<ApiResult<ListStoreProductsResponse>> listStoreProducts(
    StoreId storeId,
  ) async {
    try {
      final products = await _list(storeId);
      final items = products.map(_toResponse).toList();
      return ApiSuccess(
        ListStoreProductsResponse(items: items),
        statusCode: 200,
      );
    } on CredentialFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 401,
      );
    } on ForbiddenFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 403,
      );
    } on SessionExpiredFailure catch (e) {
      return ApiFailure(
        ApiErrorBody(code: e.code, message: e.message),
        statusCode: 401,
      );
    }
  }

  ProductResponse _toResponse(Product product) => ProductResponse(
        id: product.id,
        name: product.name,
        salePriceClp: product.salePriceClp,
        stock: product.stock,
        qrPayload: product.qrPayload,
      );

  ProductSearchItem _toSearchItem(Product product) => ProductSearchItem(
        id: product.id,
        name: product.name,
        salePriceClp: product.salePriceClp,
        stock: product.stock,
      );

  /// Expuesto para tests de integración con repositorio compartido.
  ProductRepository get repository => _repository;
}