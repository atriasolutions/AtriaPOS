import '../domain/domain.dart';
import 'auth_helpers.dart';
import 'emit_sale_dte.dart';
import 'ports/session_provider.dart';
import 'ports/cart_repository.dart';
import 'ports/dte_gateway.dart';
import 'ports/dte_queue_repository.dart';
import 'ports/product_repository.dart';
import 'ports/sale_repository.dart';
import 'ports/shift_repository.dart';
import 'ports/stock_movement_repository.dart';
import 'ports/trusted_clock.dart';

class CheckoutPaymentInput {
  const CheckoutPaymentInput({
    required this.method,
    required this.amountClp,
  });

  final PaymentMethod method;
  final int amountClp;
}

class ConfirmCheckoutInput {
  const ConfirmCheckoutInput({
    required this.storeId,
    required this.cartId,
    required this.payments,
    required this.changeClp,
  });

  final StoreId storeId;
  final CartId cartId;
  final List<CheckoutPaymentInput> payments;
  final int changeClp;
}

class ConfirmCheckoutResult {
  const ConfirmCheckoutResult({
    required this.saleId,
    required this.totalClp,
    required this.dteStatus,
    required this.createdAt,
    this.folio,
    this.pdfUrl,
  });

  final SaleId saleId;
  final int totalClp;
  final DteStatus dteStatus;
  final DateTime createdAt;
  final int? folio;
  final String? pdfUrl;
}

class ConfirmCheckout {
  ConfirmCheckout(
    this._carts,
    this._products,
    this._sales,
    this._movements,
    this._shifts,
    this._dte,
    this._dteQueue,
    this._sessions, [
    TrustedClock? clock,
  ]) : _clock = clock ?? MutableTrustedClock();

  final CartRepository _carts;
  final ProductRepository _products;
  final SaleRepository _sales;
  final StockMovementRepository _movements;
  final ShiftRepository _shifts;
  final DteGateway _dte;
  final DteQueueRepository _dteQueue;
  final SessionProvider _sessions;
  final TrustedClock _clock;

  Future<ConfirmCheckoutResult> call(ConfirmCheckoutInput input) async {
    final session = requireActiveSession(_sessions);
    AuthPolicy.require(session, Permission.vender);
    final actorId = session.userId;
    final openShift = await _shifts.findOpenByStore(input.storeId);
    if (openShift == null) {
      throw const TurnClosedFailure(
        'No hay turno abierto. Abra turno antes de vender.',
      );
    }

    final cart = await _carts.findById(input.storeId, input.cartId);
    if (cart == null) {
      throw NotFoundFailure(
        'Carro no encontrado',
        details: {'cartId': input.cartId},
      );
    }
    if (cart.status != CartStatus.open) {
      throw const ValidationFailure('El carro ya no está abierto');
    }
    if (cart.isEmpty) {
      throw const ValidationFailure('No se puede confirmar un carro vacío');
    }

    for (final line in cart.lines) {
      final product = await _products.findById(input.storeId, line.productId);
      if (product == null) {
        throw NotFoundFailure(
          'Producto no encontrado',
          details: {'productId': line.productId},
        );
      }
      if (product.blockWhenOutOfStock && line.quantity > product.stock) {
        throw InsufficientStockFailure(
          'No hay stock suficiente para ${product.name}',
          details: {'productId': product.id},
        );
      }
    }

    final totalClp = saleTotalClp(cart.lines);
    final paymentEntities = <Payment>[];
    for (final p in input.payments) {
      paymentEntities.add(Payment.create(method: p.method, amountClp: p.amountClp));
    }
    final paidClp =
        paymentEntities.fold<int>(0, (sum, p) => sum + p.amountClp);
    if (paidClp < totalClp) {
      throw const ValidationFailure('El pago es menor al total de la venta');
    }
    if (input.changeClp != paidClp - totalClp) {
      throw const ValidationFailure('El vuelto no coincide con los pagos');
    }

    final saleLines = cart.lines.map(SaleLine.fromCartLine).toList();
    var sale = Sale(
      id: newSaleId(),
      storeId: input.storeId,
      shiftId: openShift.id,
      cartId: cart.id,
      lines: saleLines,
      payments: paymentEntities,
      totalClp: totalClp,
      changeClp: input.changeClp,
      createdAt: _clock.now(),
      confirmedByUserId: actorId,
    );

    for (final line in cart.lines) {
      final product = await _products.findById(input.storeId, line.productId);
      if (product == null) {
        throw NotFoundFailure(
          'Producto no encontrado',
          details: {'productId': line.productId},
        );
      }
      final updated = product.applyStockDelta(-line.quantity);
      await _products.save(updated);
      await _movements.save(
        StockMovement.record(
          storeId: input.storeId,
          productId: line.productId,
          delta: -line.quantity,
          reason: StockAdjustmentReason.venta,
          note: 'Venta ${sale.id}',
          actorId: actorId,
          createdAt: sale.createdAt,
        ),
      );
    }

    await _sales.save(sale);
    sale = await emitSaleDte(sale, _dte, _dteQueue, _clock);
    await _sales.save(sale);
    await _carts.save(cart.markCompleted());

    return ConfirmCheckoutResult(
      saleId: sale.id,
      totalClp: totalClp,
      dteStatus: sale.dteStatus,
      createdAt: sale.createdAt,
      folio: sale.folio,
      pdfUrl: sale.pdfUrl,
    );
  }
}