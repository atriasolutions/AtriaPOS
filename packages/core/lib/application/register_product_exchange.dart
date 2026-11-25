import '../domain/domain.dart';
import 'auth_helpers.dart';
import 'ports/product_exchange_repository.dart';
import 'ports/product_repository.dart';
import 'ports/sale_repository.dart';
import 'ports/session_provider.dart';
import 'ports/shift_repository.dart';
import 'ports/stock_movement_repository.dart';
import 'ports/trusted_clock.dart';

class ProductExchangePaymentInput {
  const ProductExchangePaymentInput({
    required this.method,
    required this.amountClp,
  });

  final PaymentMethod method;
  final int amountClp;
}

class RegisterProductExchangeInput {
  const RegisterProductExchangeInput({
    required this.storeId,
    required this.saleId,
    required this.returnProductId,
    required this.returnQuantity,
    required this.newProductId,
    required this.newQuantity,
    this.differencePayment,
  });

  final StoreId storeId;
  final SaleId saleId;
  final ProductId returnProductId;
  final int returnQuantity;
  final ProductId newProductId;
  final int newQuantity;
  final ProductExchangePaymentInput? differencePayment;
}

class RegisterProductExchangeResult {
  const RegisterProductExchangeResult({
    required this.exchange,
    required this.newSale,
    required this.returnProductStock,
    required this.newProductStock,
  });

  final ProductExchange exchange;
  final Sale newSale;
  final int returnProductStock;
  final int newProductStock;
}

class RegisterProductExchange {
  RegisterProductExchange(
    this._sales,
    this._products,
    this._movements,
    this._shifts,
    this._exchanges,
    this._sessions, [
    TrustedClock? clock,
  ]) : _clock = clock ?? MutableTrustedClock();

  final SaleRepository _sales;
  final ProductRepository _products;
  final StockMovementRepository _movements;
  final ShiftRepository _shifts;
  final ProductExchangeRepository _exchanges;
  final SessionProvider _sessions;
  final TrustedClock _clock;

  Future<RegisterProductExchangeResult> call(
    RegisterProductExchangeInput input,
  ) async {
    final session = requireActiveSession(_sessions);
    AuthPolicy.require(session, Permission.cambiarProducto);
    final actorId = session.userId;

    if (input.returnQuantity <= 0 || input.newQuantity <= 0) {
      throw const ValidationFailure('Las cantidades deben ser mayores a cero');
    }

    final sale = await _sales.findById(input.storeId, input.saleId);
    if (sale == null) {
      throw NotFoundFailure(
        'Venta no encontrada',
        details: {'saleId': input.saleId},
      );
    }
    if (sale.isAnulada) {
      throw const ValidationFailure(
        'No se puede cambiar producto en una venta anulada',
      );
    }
    if (sale.dteStatus == DteStatus.emitida) {
      throw const ValidationFailure(
        'No se puede cambiar producto con boleta emitida. '
        'Registre nota de crédito antes del cambio.',
      );
    }

    final openShift = await _shifts.findOpenByStore(input.storeId);
    if (openShift == null) {
      throw const TurnClosedFailure(
        'No hay turno abierto. No se puede registrar el cambio.',
      );
    }
    if (sale.shiftId != openShift.id) {
      throw const ValidationFailure(
        'Solo se pueden cambiar productos en ventas del turno abierto',
      );
    }

    var lineQty = 0;
    int? originalUnitPrice;
    for (final line in sale.lines) {
      if (line.productId == input.returnProductId) {
        lineQty += line.quantity;
        originalUnitPrice ??= line.unitPriceClp;
      }
    }
    if (lineQty == 0 || originalUnitPrice == null) {
      throw NotFoundFailure(
        'El producto no figura en la venta',
        details: {'productId': input.returnProductId},
      );
    }

    final alreadyReturned = await _exchanges.sumReturnedQty(
      input.storeId,
      input.saleId,
      input.returnProductId,
    );
    final available = lineQty - alreadyReturned;
    if (input.returnQuantity > available) {
      if (available <= 0) {
        throw const ConflictFailure(
          'Ya no quedan unidades disponibles para cambio en este producto',
        );
      }
      throw ValidationFailure(
        'Cantidad a devolver supera lo disponible ($available)',
      );
    }

    final returnProduct =
        await _products.findById(input.storeId, input.returnProductId);
    if (returnProduct == null) {
      throw NotFoundFailure(
        'Producto no encontrado',
        details: {'productId': input.returnProductId},
      );
    }

    final newProduct = await _products.findById(input.storeId, input.newProductId);
    if (newProduct == null) {
      throw NotFoundFailure(
        'Producto nuevo no encontrado',
        details: {'productId': input.newProductId},
      );
    }
    if (newProduct.blockWhenOutOfStock &&
        input.newQuantity > newProduct.stock) {
      throw InsufficientStockFailure(
        'No hay stock suficiente para ${newProduct.name}',
        details: {'productId': newProduct.id},
      );
    }

    final creditClp = input.returnQuantity * originalUnitPrice;
    final newUnitPrice = newProduct.salePriceClp;
    final chargeClp = input.newQuantity * newUnitPrice;
    final differenceClp = chargeClp - creditClp;

    PaymentMethod? diffMethod;
    int? diffAmount;
    if (differenceClp > 0) {
      final pay = input.differencePayment;
      if (pay == null) {
        throw const ValidationFailure(
          'Debe registrar el pago por la diferencia a favor',
        );
      }
      if (pay.amountClp != differenceClp) {
        throw const ValidationFailure(
          'El monto del pago no coincide con la diferencia',
        );
      }
      diffMethod = pay.method;
      diffAmount = pay.amountClp;
    } else if (differenceClp < 0) {
      final pay = input.differencePayment;
      if (pay == null) {
        throw const ValidationFailure(
          'Debe registrar la devolución por la diferencia',
        );
      }
      final expected = -differenceClp;
      if (pay.amountClp != expected) {
        throw const ValidationFailure(
          'El monto de devolución no coincide con la diferencia',
        );
      }
      diffMethod = pay.method;
      diffAmount = pay.amountClp;
    } else if (input.differencePayment != null) {
      throw const ValidationFailure(
        'No se requiere pago cuando no hay diferencia',
      );
    }

    final createdAt = _clock.now().toUtc();
    final exchangeId = newProductExchangeId();
    final createdSaleId = newSaleId();

    final payments = <Payment>[];
    if (differenceClp > 0 && diffMethod != null && diffAmount != null) {
      payments.add(Payment.create(method: diffMethod, amountClp: diffAmount));
    }

    final newSale = Sale(
      id: createdSaleId,
      storeId: input.storeId,
      shiftId: openShift.id,
      cartId: 'exchange-$exchangeId',
      lines: [
        SaleLine(
          productId: newProduct.id,
          productName: newProduct.name,
          quantity: input.newQuantity,
          unitPriceClp: newUnitPrice,
        ),
      ],
      payments: payments,
      totalClp: chargeClp,
      changeClp: 0,
      createdAt: createdAt,
      confirmedByUserId: actorId,
      sellerCode: sale.sellerCode,
      dteStatus: DteStatus.pendienteDte,
    );

    final updatedReturn = returnProduct.applyStockDelta(input.returnQuantity);
    await _products.save(updatedReturn);
    await _movements.save(
      StockMovement.record(
        storeId: input.storeId,
        productId: returnProduct.id,
        delta: input.returnQuantity,
        reason: StockAdjustmentReason.cambioDevolucion,
        note: 'Cambio $exchangeId venta ${sale.id}',
        actorId: actorId,
        createdAt: createdAt,
      ),
    );

    final updatedNew = newProduct.applyStockDelta(-input.newQuantity);
    await _products.save(updatedNew);
    await _movements.save(
      StockMovement.record(
        storeId: input.storeId,
        productId: newProduct.id,
        delta: -input.newQuantity,
        reason: StockAdjustmentReason.cambioEntrega,
        note: 'Cambio $exchangeId venta ${sale.id}',
        actorId: actorId,
        createdAt: createdAt,
      ),
    );

    await _sales.save(newSale);

    final exchange = ProductExchange(
      id: exchangeId,
      storeId: input.storeId,
      shiftId: openShift.id,
      originalSaleId: sale.id,
      returnProductId: input.returnProductId,
      returnQuantity: input.returnQuantity,
      originalUnitPriceClp: originalUnitPrice,
      newProductId: input.newProductId,
      newQuantity: input.newQuantity,
      newUnitPriceClp: newUnitPrice,
      creditClp: creditClp,
      chargeClp: chargeClp,
      differenceClp: differenceClp,
      newSaleId: createdSaleId,
      createdAt: createdAt,
      actorUserId: actorId,
      differencePaymentMethod: diffMethod,
      differencePaymentAmountClp: diffAmount,
    );
    await _exchanges.save(exchange);

    return RegisterProductExchangeResult(
      exchange: exchange,
      newSale: newSale,
      returnProductStock: updatedReturn.stock,
      newProductStock: updatedNew.stock,
    );
  }
}