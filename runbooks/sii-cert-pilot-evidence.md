# Evidencia piloto SC-080-03

Completar en dispositivo piloto con certificación real (no commitear capturas con datos sensibles).

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

- Si el SII rechaza el XML, registrar `dteStatus` y mensaje en cola/logs locales.
- Tras piloto exitoso, marcar DoD SLICE-8 en [`docs/10-plan-entregas.md`](../docs/10-plan-entregas.md).