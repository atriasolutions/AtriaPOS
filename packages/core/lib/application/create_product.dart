import '../domain/domain.dart';
import 'auth_helpers.dart';
import 'ports/product_repository.dart';
import 'ports/session_provider.dart';

class CreateProductInput {
  const CreateProductInput({
    required this.storeId,
    required this.name,
    required this.salePriceClp,
    this.initialStock = 0,
    this.barcode,
    this.costClp,
    this.blockWhenOutOfStock = true,
  });

  final StoreId storeId;
  final String name;
  final int salePriceClp;
  final int initialStock;
  final String? barcode;
  final int? costClp;
  final bool blockWhenOutOfStock;
}

class CreateProduct {
  CreateProduct(this._repository, this._sessions);

  final ProductRepository _repository;
  final SessionProvider _sessions;

  Future<Product> call(CreateProductInput input) async {
    AuthPolicy.require(
      requireActiveSession(_sessions),
      Permission.configurarCatalogo,
    );
    if (input.barcode != null && input.barcode!.trim().isNotEmpty) {
      final existing = await _repository.findByBarcode(
        input.storeId,
        input.barcode!.trim(),
      );
      if (existing != null) {
        throw ConflictFailure(
          'Ya existe un producto con ese código de barras',
          details: {'barcode': input.barcode!.trim()},
        );
      }
    }

    final product = Product.create(
      id: newProductId(),
      storeId: input.storeId,
      name: input.name,
      salePriceClp: input.salePriceClp,
      initialStock: input.initialStock,
      barcode: input.barcode,
      costClp: input.costClp,
      blockWhenOutOfStock: input.blockWhenOutOfStock,
    );

    await _repository.save(product);
    return product;
  }
}