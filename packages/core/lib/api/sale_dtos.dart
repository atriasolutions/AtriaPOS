class CreateCartResponse {
  const CreateCartResponse({required this.cartId});

  final String cartId;
}

class CartLineResponse {
  const CartLineResponse({
    required this.lineId,
    required this.productId,
    required this.name,
    required this.quantity,
    required this.unitPriceClp,
  });

  final String lineId;
  final String productId;
  final String name;
  final int quantity;
  final int unitPriceClp;
}

class CartResponse {
  const CartResponse({
    required this.cartId,
    required this.lines,
    required this.totalClp,
  });

  final String cartId;
  final List<CartLineResponse> lines;
  final int totalClp;
}

class AddCartLineRequest {
  const AddCartLineRequest({
    required this.productId,
    required this.quantity,
  });

  final String productId;
  final int quantity;
}

class UpdateCartLineRequest {
  const UpdateCartLineRequest({required this.quantity});

  final int quantity;
}

class CheckoutPaymentDto {
  const CheckoutPaymentDto({
    required this.method,
    required this.amountClp,
  });

  final String method;
  final int amountClp;
}

class CheckoutRequest {
  const CheckoutRequest({
    required this.payments,
    required this.changeClp,
  });

  final List<CheckoutPaymentDto> payments;
  final int changeClp;
}

class VoidSaleResponse {
  const VoidSaleResponse({
    required this.saleId,
    required this.status,
  });

  final String saleId;
  final String status;
}

class ShiftSaleItemResponse {
  const ShiftSaleItemResponse({
    required this.saleId,
    required this.totalClp,
    required this.status,
    required this.dteStatus,
    this.folio,
  });

  final String saleId;
  final int totalClp;
  final String status;
  final String dteStatus;
  final int? folio;
}

class ListShiftSalesResponse {
  const ListShiftSalesResponse({required this.items});

  final List<ShiftSaleItemResponse> items;
}

class CheckoutResponse {
  const CheckoutResponse({
    required this.saleId,
    required this.totalClp,
    required this.dteStatus,
    this.folio,
    this.pdfUrl,
  });

  final String saleId;
  final int totalClp;
  final String dteStatus;
  final int? folio;
  final String? pdfUrl;
}