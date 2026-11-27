import 'package:adapters/adapters.dart';
import 'package:core/atria_pos_core.dart';
import 'package:test/test.dart';

void main() {
  test('XML boleta incluye folio y emisor', () {
    const emisor = SiiEmisorConfig(
      rutEmisor: '76192083-9',
      razonSocial: 'Minimarket',
      giro: 'Almacen',
    );
    final sale = Sale(
      id: 's1',
      storeId: 't1',
      shiftId: 'sh1',
      cartId: 'c1',
      lines: [
        SaleLine(
          productId: 'p1',
          productName: 'Pan',
          quantity: 1,
          unitPriceClp: 500,
        ),
      ],
      payments: [
        Payment.create(method: PaymentMethod.efectivo, amountClp: 500),
      ],
      totalClp: 500,
      changeClp: 0,
      createdAt: DateTime.utc(2026, 1, 1),
    );
    final xml = SiiDteXmlBuilder().buildDocumento(
      sale: sale,
      folio: 9001,
      emisor: emisor,
    );
    expect(xml, contains('<TipoDTE>39</TipoDTE>'));
    expect(xml, contains('<Folio>9001</Folio>'));
    expect(xml, contains('76192083-9'));
    expect(xml, contains('Minimarket'));
    expect(xml, contains('<MntTotal>500</MntTotal>'));
  });

  test('SC-093 XML factura 33 incluye receptor', () {
    const emisor = SiiEmisorConfig(
      rutEmisor: '76192083-9',
      razonSocial: 'Minimarket',
      giro: 'Almacen',
    );
    final sale = Sale(
      id: 's2',
      storeId: 't1',
      shiftId: 'sh1',
      cartId: 'c2',
      lines: [
        SaleLine(
          productId: 'p1',
          productName: 'Pan',
          quantity: 1,
          unitPriceClp: 500,
        ),
      ],
      payments: [
        Payment.create(method: PaymentMethod.efectivo, amountClp: 500),
      ],
      totalClp: 500,
      changeClp: 0,
      createdAt: DateTime.utc(2026, 1, 1),
      dteDocumentType: DteDocumentType.factura,
      invoiceReceiver: SaleInvoiceReceiver.validate(
        rutRaw: '12.345.678-5',
        businessNameRaw: 'Cliente SpA',
        giroRaw: 'Abarrotes',
        emailRaw: 'cliente@correo.cl',
        addressRaw: 'Av. 1 100',
        cityRaw: 'Santiago',
        communeRaw: 'Nunoa',
        phoneRaw: '912345678',
      ),
    );
    final xml = SiiDteXmlBuilder().buildDocumento(
      sale: sale,
      folio: 7001,
      emisor: emisor,
    );
    expect(xml, contains('<TipoDTE>33</TipoDTE>'));
    expect(xml, contains('<Receptor>'));
    expect(xml, contains('12.345.678-5'));
    expect(xml, contains('Cliente SpA'));
    expect(xml, contains('<GiroRecep>Abarrotes</GiroRecep>'));
    expect(xml, contains('<CmnaRecep>Nunoa</CmnaRecep>'));
  });
}