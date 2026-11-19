# Evidencia piloto SC-080-03

Completar en dispositivo piloto con certificación real (no commitear capturas con datos sensibles).

Índice operativo: [`sii-piloto-indice.md`](sii-piloto-indice.md).

## Estado del documento

| Estado | Significado |
|--------|-------------|
| PREPARADO | Runbooks leídos; Gate 0 y variables listas; piloto no ejecutado |
| CERRADO | Venta cert con folio validado en portal SII; rollback probado |

Estado actual: **PREPARADO** _(operador actualiza a CERRADO al terminar)_

## Pre-vuelo

| Ítem | Hecho |
|------|-------|
| [`docs/gate0-slice8b-piloto.md`](../docs/gate0-slice8b-piloto.md) completado | ☐ Gate 0 |
| [`sii-cert.md`](sii-cert.md) Fase B — variables definidas | ☐ |
| Certificado y CAF solo en dispositivo | ☐ |
| App muestra certificado válido (pantalla Certificado SII) | ☐ |

## Evidencia emisión

| Campo | Valor |
|-------|-------|
| Fecha piloto | _(completar)_ |
| Operador | _(completar)_ |
| RUT emisor | _(completar)_ |
| Folio emitido | _(completar)_ |
| Venta `sale_id` local | _(completar)_ |
| Portal SII folio visible | ☐ Sí — adjuntar captura fuera del repo |
| Rollback a `SII_GATEWAY=fake` probado | ☐ Sí |

## Notas

- El campo **Venta `sale_id` local** coincide con la línea `Venta (sale_id): …` del diálogo post-checkout en la pantalla Vender.
- Si el SII rechaza el XML, registrar `dteStatus` y mensaje en cola/logs locales.
- Tras piloto exitoso (estado **CERRADO**), marcar DoD SLICE-8 en [`docs/10-plan-entregas.md`](../docs/10-plan-entregas.md).