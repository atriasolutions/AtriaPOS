import 'package:core/application/ports/dte_gateway.dart';
import 'package:core/atria_pos_core.dart';
import 'package:xml/xml.dart';

import 'sii_emisor_config.dart';

/// XML boleta 39 mínimo para ambiente certificación.
class SiiDteXmlBuilder {
  String buildDocumento({
    required Sale sale,
    required int folio,
    required SiiEmisorConfig emisor,
  }) {
    final tipoDte = sale.dteDocumentType;
    final builder = XmlBuilder();
    builder.element(
      'Documento',
      attributes: {
        'ID': 'DOC_${sale.id}_$folio',
      },
      nest: () {
        builder.element('TipoDTE', nest: () => builder.text('$tipoDte'));
        builder.element('Folio', nest: () => builder.text('$folio'));
        builder.element(
          'Emisor',
          nest: () {
            builder.element('RUT', nest: () => builder.text(emisor.rutEmisor));
            builder.element('RznSoc', nest: () => builder.text(emisor.razonSocial));
            builder.element('GiroEmis', nest: () => builder.text(emisor.giro));
          },
        );
        if (tipoDte == DteDocumentType.factura) {
          final receiver = sale.invoiceReceiver;
          if (receiver != null) {
            builder.element(
              'Receptor',
              nest: () {
                builder.element('RUT', nest: () => builder.text(receiver.rut));
                builder.element(
                  'RznSoc',
                  nest: () => builder.text(receiver.businessName),
                );
                builder.element(
                  'GiroRecep',
                  nest: () => builder.text(receiver.giro),
                );
                builder.element(
                  'DirRecep',
                  nest: () => builder.text(receiver.address),
                );
                builder.element(
                  'CmnaRecep',
                  nest: () => builder.text(receiver.commune),
                );
                builder.element(
                  'CiudadRecep',
                  nest: () => builder.text(receiver.city),
                );
              },
            );
          }
        }
        builder.element('MntTotal', nest: () => builder.text('${sale.totalClp}'));
        builder.element(
          'Detalle',
          nest: () {
            for (final line in sale.lines) {
              builder.element(
                'Item',
                nest: () {
                  builder.element('NmbItem', nest: () => builder.text(line.productName));
                  builder.element('QtyItem', nest: () => builder.text('${line.quantity}'));
                  builder.element(
                    'PrcItem',
                    nest: () => builder.text('${line.unitPriceClp}'),
                  );
                },
              );
            }
          },
        );
      },
    );
    final doc = builder.buildDocument();
    return doc.toXmlString(pretty: false);
  }

  String buildNotaCredito({
    required Sale sale,
    required int folio,
    required SiiEmisorConfig emisor,
    required int referencedFolio,
    required int referencedDocumentType,
    required List<DteCreditNoteLineRequest> lines,
    required int totalClp,
  }) {
    final builder = XmlBuilder();
    builder.element(
      'Documento',
      attributes: {
        'ID': 'NC_${sale.id}_$folio',
      },
      nest: () {
        builder.element('TipoDTE', nest: () => builder.text('61'));
        builder.element('Folio', nest: () => builder.text('$folio'));
        builder.element(
          'Referencia',
          nest: () {
            builder.element(
              'TpoDocRef',
              nest: () => builder.text('$referencedDocumentType'),
            );
            builder.element('FolioRef', nest: () => builder.text('$referencedFolio'));
            builder.element('FchRef', nest: () => builder.text('${sale.createdAt.toIso8601String().split('T').first}'));
          },
        );
        builder.element(
          'Emisor',
          nest: () {
            builder.element('RUT', nest: () => builder.text(emisor.rutEmisor));
            builder.element('RznSoc', nest: () => builder.text(emisor.razonSocial));
            builder.element('GiroEmis', nest: () => builder.text(emisor.giro));
          },
        );
        builder.element('MntTotal', nest: () => builder.text('$totalClp'));
        builder.element(
          'Detalle',
          nest: () {
            for (final line in lines) {
              builder.element(
                'Item',
                nest: () {
                  builder.element('NmbItem', nest: () => builder.text(line.productName));
                  builder.element('QtyItem', nest: () => builder.text('${line.quantity}'));
                  builder.element(
                    'PrcItem',
                    nest: () => builder.text('${line.unitPriceClp}'),
                  );
                },
              );
            }
          },
        );
      },
    );
    return builder.buildDocument().toXmlString(pretty: false);
  }
}