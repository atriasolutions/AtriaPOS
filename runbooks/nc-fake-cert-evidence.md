# Evidencia nota de crédito y factura (fake / cert)

Sin certificados ni secretos en repo.

## Fake (desarrollo / CI)

- `dart test packages/core` — SC-092-* y SC-093-* con `FakeDteGateway`.
- `dart test packages/adapters/test/credit_note_xml_test.dart` — XML tipo 61.
- `dart test packages/adapters/test/sii_dte_xml_builder_test.dart` — factura tipo 33 + receptor.
- `flutter test apps/pos_app/test/invoice_checkout_ui_e2e_test.dart` — checkout factura UI.

## Certificación SII (manual)

- [ ] CAF tipo **61** cargado en folio allocator de la tienda.
- [ ] CAF tipo **33** para factura (piloto cert, manual).
- [ ] Checkout factura con receptor real en ambiente cert; captura folio 33.
- [ ] Certificado vigente en dispositivo (`validateCertificate` OK).
- [ ] Venta con boleta **EMITIDA** en turno abierto.
- [ ] `POST .../credit-notes` → folio NC y stock `NOTA_CREDITO` en auditoría.
- [ ] Cola vacía tras emisión exitosa; reintento si `PENDIENTE_DTE`.

## Piloto live

Fuera de MVP demo; seguir runbooks boleta existentes y repetir checklist con ambiente productivo acordado con el cliente.