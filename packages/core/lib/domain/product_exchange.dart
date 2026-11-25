import 'payment_method.dart';
import 'product_exchange_id.dart';
import 'product_id.dart';
import 'sale_id.dart';
import 'shift_id.dart';
import 'store_id.dart';
import 'user_id.dart';

class ProductExchange {
  const ProductExchange({
    required this.id,
    required this.storeId,
    required this.shiftId,
    required this.originalSaleId,
    required this.returnProductId,
    required this.returnQuantity,
    required this.originalUnitPriceClp,
    required this.newProductId,
    required this.newQuantity,
    required this.newUnitPriceClp,
    required this.creditClp,
    required this.chargeClp,
    required this.differenceClp,
    required this.newSaleId,
    required this.createdAt,
    required this.actorUserId,
    this.differencePaymentMethod,
    this.differencePaymentAmountClp,
    this.creditNoteId,
  });

  final ProductExchangeId id;
  final StoreId storeId;
  final ShiftId shiftId;
  final SaleId originalSaleId;
  final ProductId returnProductId;
  final int returnQuantity;
  final int originalUnitPriceClp;
  final ProductId newProductId;
  final int newQuantity;
  final int newUnitPriceClp;
  final int creditClp;
  final int chargeClp;
  final int differenceClp;
  final SaleId newSaleId;
  final DateTime createdAt;
  final UserId actorUserId;
  final PaymentMethod? differencePaymentMethod;
  final int? differencePaymentAmountClp;
  final String? creditNoteId;
}