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
    final builder = XmlBuilder();
    builder.element(
      'Documento',
      attributes: {
        'ID': 'DOC_${sale.id}_$folio',
      },
      nest: () {
        builder.element('TipoDTE', nest: () => builder.text('39'));
        builder.element('Folio', nest: () => builder.text('$folio'));
        builder.element(
          'Emisor',
          nest: () {
            builder.element('RUT', nest: () => builder.text(emisor.rutEmisor));
            builder.element('RznSoc', nest: () => builder.text(emisor.razonSocial));
            builder.element('GiroEmis', nest: () => builder.text(emisor.giro));
          },
        );
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
}