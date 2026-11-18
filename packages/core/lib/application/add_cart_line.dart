import '../domain/domain.dart';
import 'ports/cart_repository.dart';
import 'ports/product_repository.dart';

class AddCartLineInput {
  const AddCartLineInput({
    required this.storeId,
    required this.cartId,
    required this.productId,
    required this.quantity,
  });

  final StoreId storeId;
  final CartId cartId;
  final ProductId productId;
  final int quantity;
}

class AddCartLine {
  AddCartLine(this._carts, this._products);

  final CartRepository _carts;
  final ProductRepository _products;

  Future<Cart> call(AddCartLineInput input) async {
    final cart = await _requireOpenCart(input.storeId, input.cartId);
    final product =
        await _products.findById(input.storeId, input.productId);
    if (product == null) {
      throw NotFoundFailure(
        'Producto no encontrado',
        details: {'productId': input.productId},
      );
    }

    final line = CartLine.create(
      productId: product.id,
      productName: product.name,
      quantity: input.quantity,
      unitPriceClp: product.salePriceClp,
    );
    final updated = cart.addLine(line);
    await _carts.save(updated);
    return updated;
  }

  Future<Cart> _requireOpenCart(StoreId storeId, CartId cartId) async {
    final cart = await _carts.findById(storeId, cartId);
    if (cart == null) {
      throw NotFoundFailure(
        'Carro no encontrado',
        details: {'cartId': cartId},
      );
    }
    if (cart.status != CartStatus.open) {
      throw const ValidationFailure('El carro ya no está abierto');
    }
    return cart;
  }
}