import 'package:adapters/sii_dte_xml_builder.dart';
import 'package:adapters/sii_emisor_config.dart';
import 'package:core/application/ports/dte_gateway.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  test('SC-092 XML nota de crédito tipo 61', () {
    final sale = Sale(
      id: 'sale_x',
      storeId: 't1',
      shiftId: 'sh1',
      cartId: 'c1',
      lines: const [],
      payments: const [],
      totalClp: 500,
      changeClp: 0,
      createdAt: DateTime.utc(2026, 1, 2),
      dteStatus: DteStatus.emitida,
      folio: 9,
    );
    final xml = SiiDteXmlBuilder().buildNotaCredito(
      sale: sale,
      folio: 3,
      emisor: const SiiEmisorConfig(
        rutEmisor: '11.111.111-1',
        razonSocial: 'Tienda',
        giro: 'Retail',
      ),
      referencedFolio: 9,
      referencedDocumentType: DteDocumentType.boleta,
      lines: const [
        DteCreditNoteLineRequest(
          productName: 'Pan',
          quantity: 1,
          unitPriceClp: 500,
        ),
      ],
      totalClp: 500,
    );
    expect(xml, contains('<TipoDTE>61</TipoDTE>'));
    expect(xml, contains('<FolioRef>9</FolioRef>'));
  });

  test('SC-093-07 NC referencia factura tipo 33', () {
    final sale = Sale(
      id: 'sale_f',
      storeId: 't1',
      shiftId: 'sh1',
      cartId: 'c1',
      lines: const [],
      payments: const [],
      totalClp: 500,
      changeClp: 0,
      createdAt: DateTime.utc(2026, 1, 2),
      dteStatus: DteStatus.emitida,
      folio: 12,
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
    final xml = SiiDteXmlBuilder().buildNotaCredito(
      sale: sale,
      folio: 4,
      emisor: const SiiEmisorConfig(
        rutEmisor: '11.111.111-1',
        razonSocial: 'Tienda',
        giro: 'Retail',
      ),
      referencedFolio: 12,
      referencedDocumentType: DteDocumentType.factura,
      lines: const [
        DteCreditNoteLineRequest(
          productName: 'Pan',
          quantity: 1,
          unitPriceClp: 500,
        ),
      ],
      totalClp: 500,
    );
    expect(xml, contains('<TpoDocRef>33</TpoDocRef>'));
  });
}