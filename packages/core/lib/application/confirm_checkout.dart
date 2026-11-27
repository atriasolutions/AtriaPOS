import '../domain/domain.dart';
import 'auth_helpers.dart';
import 'emit_sale_dte.dart';
import 'ports/session_provider.dart';
import 'ports/cart_repository.dart';
import 'ports/invoice_customer_repository.dart';
import 'ports/collaborator_repository.dart';
import 'ports/dte_gateway.dart';
import 'ports/dte_queue_repository.dart';
import 'ports/product_repository.dart';
import 'ports/sale_repository.dart';
import 'ports/shift_repository.dart';
import 'ports/stock_movement_repository.dart';
import 'ports/store_repository.dart';
import 'ports/trusted_clock.dart';

class CheckoutPaymentInput {
  const CheckoutPaymentInput({
    required this.method,
    required this.amountClp,
  });

  final PaymentMethod method;
  final int amountClp;
}

class ConfirmCheckoutInvoiceReceiverInput {
  const ConfirmCheckoutInvoiceReceiverInput({
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

  bool get hasAnyData =>
      rut.trim().isNotEmpty ||
      businessName.trim().isNotEmpty ||
      giro.trim().isNotEmpty ||
      email.trim().isNotEmpty ||
      address.trim().isNotEmpty ||
      city.trim().isNotEmpty ||
      commune.trim().isNotEmpty ||
      phone.trim().isNotEmpty;
}

class ConfirmCheckoutInput {
  const ConfirmCheckoutInput({
    required this.storeId,
    required this.cartId,
    required this.sellerCode,
    required this.payments,
    required this.changeClp,
    this.documentKind = CheckoutDocumentKind.boleta,
    this.invoiceReceiver,
  });

  final StoreId storeId;
  final CartId cartId;
  final String sellerCode;
  final List<CheckoutPaymentInput> payments;
  final int changeClp;
  final CheckoutDocumentKind documentKind;
  final ConfirmCheckoutInvoiceReceiverInput? invoiceReceiver;
}

class ConfirmCheckoutResult {
  const ConfirmCheckoutResult({
    required this.saleId,
    required this.totalClp,
    required this.sellerCode,
    required this.dteStatus,
    required this.createdAt,
    this.folio,
    this.pdfUrl,
    this.dteDocumentType = DteDocumentType.boleta,
  });

  final SaleId saleId;
  final int totalClp;
  final String sellerCode;
  final DteStatus dteStatus;
  final DateTime createdAt;
  final int? folio;
  final String? pdfUrl;
  final int dteDocumentType;
}

class ConfirmCheckout {
  ConfirmCheckout(
    this._carts,
    this._products,
    this._sales,
    this._movements,
    this._shifts,
    this._collaborators,
    this._stores,
    this._dte,
    this._dteQueue,
    this._sessions, [
    TrustedClock? clock,
    InvoiceCustomerRepository? invoiceCustomers,
  ])  : _clock = clock ?? MutableTrustedClock(),
        _invoiceCustomers = invoiceCustomers;

  final CartRepository _carts;
  final ProductRepository _products;
  final SaleRepository _sales;
  final StockMovementRepository _movements;
  final ShiftRepository _shifts;
  final CollaboratorRepository _collaborators;
  final StoreRepository _stores;
  final DteGateway _dte;
  final DteQueueRepository _dteQueue;
  final SessionProvider _sessions;
  final TrustedClock _clock;
  final InvoiceCustomerRepository? _invoiceCustomers;

  Future<ConfirmCheckoutResult> call(ConfirmCheckoutInput input) async {
    final session = requireActiveSession(_sessions);
    AuthPolicy.require(session, Permission.vender);
    final actorId = session.userId;
    final store = await _stores.findById(input.storeId);
    final templateId = store?.posTemplateId ?? PosTemplateId.atriaPos;
    final requiresSeller = CheckoutTemplatePolicy.requiresSellerCode(templateId);

    SaleInvoiceReceiver? invoiceReceiver;
    final documentKind = input.documentKind;
    if (documentKind == CheckoutDocumentKind.factura) {
      if (!CheckoutTemplatePolicy.allowsInvoiceCheckout(templateId)) {
        throw const ValidationFailure(
          'La plantilla de esta tienda no permite emitir factura',
        );
      }
      final raw = input.invoiceReceiver;
      if (raw == null) {
        throw const ValidationFailure('Ingrese datos del receptor para factura');
      }
      invoiceReceiver = SaleInvoiceReceiver.validate(
        rutRaw: raw.rut,
        businessNameRaw: raw.businessName,
        giroRaw: raw.giro,
        emailRaw: raw.email,
        addressRaw: raw.address,
        cityRaw: raw.city,
        communeRaw: raw.commune,
        phoneRaw: raw.phone,
      );
    } else {
      final raw = input.invoiceReceiver;
      if (raw != null && raw.hasAnyData) {
        throw const ValidationFailure(
          'No envíe datos de receptor en venta con boleta',
        );
      }
    }
    final dteDocumentType = documentKind.dteDocumentType;
    String? sellerCode;
    if (requiresSeller) {
      if (input.sellerCode.trim().isEmpty) {
        throw const ValidationFailure('Ingrese el código vendedor');
      }
      sellerCode = SellerCodePolicy.normalize(input.sellerCode);
      final collaborator = await _collaborators.findActiveBySellerCode(
        input.storeId,
        sellerCode,
      );
      if (collaborator == null) {
        throw const ValidationFailure(
          'Código vendedor inválido o colaborador inactivo',
        );
      }
    }
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
      sellerCode: sellerCode,
      dteDocumentType: dteDocumentType,
      invoiceReceiver: invoiceReceiver,
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
    final remembered = invoiceReceiver;
    if (remembered != null) {
      await _invoiceCustomers?.save(input.storeId, remembered);
    }
    sale = await emitSaleDte(sale, _dte, _dteQueue, _clock);
    await _sales.save(sale);
    await _carts.save(cart.markCompleted());

    return ConfirmCheckoutResult(
      saleId: sale.id,
      totalClp: totalClp,
      sellerCode: sellerCode ?? '',
      dteStatus: sale.dteStatus,
      createdAt: sale.createdAt,
      folio: sale.folio,
      pdfUrl: sale.pdfUrl,
      dteDocumentType: sale.dteDocumentType,
    );
  }
}