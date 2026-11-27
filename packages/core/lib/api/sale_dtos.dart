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

class CheckoutInvoiceReceiverDto {
  const CheckoutInvoiceReceiverDto({
    required this.rut,
    required this.businessName,
    required this.giro,
    required this.email,
    required this.address,
    required this.city,
    required this.commune,
    required this.phone,
  });

  final String rut;
  final String businessName;
  final String giro;
  final String email;
  final String address;
  final String city;
  final String commune;
  final String phone;
}

class CheckoutRequest {
  const CheckoutRequest({
    required this.sellerCode,
    required this.payments,
    required this.changeClp,
    this.documentType,
    this.invoiceReceiver,
  });

  final String sellerCode;
  final List<CheckoutPaymentDto> payments;
  final int changeClp;
  final String? documentType;
  final CheckoutInvoiceReceiverDto? invoiceReceiver;
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
    this.sellerCode,
  });

  final String saleId;
  final int totalClp;
  final String status;
  final String dteStatus;
  final int? folio;
  final String? sellerCode;
}

class ListShiftSalesResponse {
  const ListShiftSalesResponse({required this.items});

  final List<ShiftSaleItemResponse> items;
}

class CheckoutResponse {
  const CheckoutResponse({
    required this.saleId,
    required this.totalClp,
    required this.sellerCode,
    required this.dteStatus,
    required this.createdAt,
    this.folio,
    this.pdfUrl,
    this.documentType,
  });

  final String saleId;
  final int totalClp;
  final String sellerCode;
  final String dteStatus;
  final String createdAt;
  final int? folio;
  final String? pdfUrl;
  final int? documentType;
}

class ActiveCollaboratorResponse {
  const ActiveCollaboratorResponse({
    required this.id,
    required this.sellerCode,
    required this.firstName,
    required this.lastName,
  });

  final String id;
  final String sellerCode;
  final String firstName;
  final String lastName;
}

class ListActiveCollaboratorsResponse {
  const ListActiveCollaboratorsResponse({required this.items});

  final List<ActiveCollaboratorResponse> items;
}

class ProductExchangePaymentDto {
  const ProductExchangePaymentDto({
    required this.method,
    required this.amountClp,
  });

  final String method;
  final int amountClp;
}

class RegisterProductExchangeRequest {
  const RegisterProductExchangeRequest({
    required this.returnProductId,
    required this.returnQuantity,
    required this.newProductId,
    required this.newQuantity,
    this.differencePayment,
    this.creditNoteId,
  });

  final String returnProductId;
  final int returnQuantity;
  final String newProductId;
  final int newQuantity;
  final ProductExchangePaymentDto? differencePayment;
  final String? creditNoteId;
}

class IssueCreditNoteLineRequest {
  const IssueCreditNoteLineRequest({
    required this.productId,
    required this.quantity,
  });

  final String productId;
  final int quantity;
}

class IssueCreditNoteRequest {
  const IssueCreditNoteRequest({this.lines = const []});

  final List<IssueCreditNoteLineRequest> lines;
}

class IssueCreditNoteReturnedLineDto {
  const IssueCreditNoteReturnedLineDto({
    required this.productId,
    required this.quantity,
    required this.stockAfter,
  });

  final String productId;
  final int quantity;
  final int stockAfter;
}

class IssueCreditNoteResponse {
  const IssueCreditNoteResponse({
    required this.creditNoteId,
    required this.folio,
    required this.dteStatus,
    required this.creditedClp,
    required this.saleStatus,
    required this.returnedLines,
  });

  final String creditNoteId;
  final int? folio;
  final String dteStatus;
  final int creditedClp;
  final String saleStatus;
  final List<IssueCreditNoteReturnedLineDto> returnedLines;
}

class SaleProductExchangeLineDto {
  const SaleProductExchangeLineDto({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPriceClp,
    required this.returnedQuantity,
    required this.availableQuantity,
  });

  final String productId;
  final String productName;
  final int quantity;
  final int unitPriceClp;
  final int returnedQuantity;
  final int availableQuantity;
}

class SaleProductExchangeContextResponse {
  const SaleProductExchangeContextResponse({
    required this.saleId,
    required this.status,
    required this.dteStatus,
    required this.lines,
  });

  final String saleId;
  final String status;
  final String dteStatus;
  final List<SaleProductExchangeLineDto> lines;
}

class RegisterProductExchangeResponse {
  const RegisterProductExchangeResponse({
    required this.exchangeId,
    required this.newSaleId,
    required this.creditClp,
    required this.chargeClp,
    required this.differenceClp,
    required this.returnProductStock,
    required this.newProductStock,
    this.creditNoteId,
  });

  final String exchangeId;
  final String newSaleId;
  final int creditClp;
  final int chargeClp;
  final int differenceClp;
  final int returnProductStock;
  final int newProductStock;
  final String? creditNoteId;
}