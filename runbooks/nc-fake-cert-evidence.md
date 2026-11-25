# Evidencia nota de crédito (fake / cert)

Sin certificados ni secretos en repo.

## Fake (desarrollo / CI)

- `dart test packages/core` — SC-092-* con `FakeDteGateway`.
- `dart test packages/adapters/test/credit_note_xml_test.dart` — XML tipo 61.

## Certificación SII (manual)

- [ ] CAF tipo **61** cargado en folio allocator de la tienda.
- [ ] Certificado vigente en dispositivo (`validateCertificate` OK).
- [ ] Venta con boleta **EMITIDA** en turno abierto.
- [ ] `POST .../credit-notes` → folio NC y stock `NOTA_CREDITO` en auditoría.
- [ ] Cola vacía tras emisión exitosa; reintento si `PENDIENTE_DTE`.

## Piloto live

Fuera de MVP demo; seguir runbooks boleta existentes y repetir checklist con ambiente productivo acordado con el cliente.