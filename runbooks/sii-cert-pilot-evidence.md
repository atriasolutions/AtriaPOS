# Evidencia piloto SC-080-03

Completar en dispositivo piloto con certificación real (no commitear capturas con datos sensibles).

Índice operativo: [`sii-piloto-indice.md`](sii-piloto-indice.md).

## Estado del documento

| Estado | Significado |
|--------|-------------|
| PREPARADO | Runbooks leídos; Gate 0 y variables listas; piloto no ejecutado |
| CERRADO | Venta cert con folio validado en portal SII; rollback probado |

Estado actual: **CERRADO** (SLICE-37, 2026-11-19)

## Pre-vuelo

| Ítem | Hecho |
|------|-------|
| [`docs/gate0-slice8b-piloto.md`](../docs/gate0-slice8b-piloto.md) completado | ☑ Gate 0 |
| [`sii-cert.md`](sii-cert.md) Fase B — variables definidas | ☑ |
| Certificado y CAF solo en dispositivo | ☑ |
| App muestra certificado válido (pantalla Certificado SII) | ☑ |

## Evidencia emisión (SLICE-37)

| Campo | Valor |
|-------|-------|
| Fecha piloto | 2026-11-19 |
| Operador | Operador piloto |
| RUT emisor | Tienda registrada en app (no versionado en repo) |
| Folio emitido | Confirmado en portal SII — número en bitácora/captura **local** del operador |
| Venta `sale_id` local | Copiado con **Copiar sale_id** — valor completo en bitácora **local** |
| Portal SII folio visible | ☑ Sí — captura fuera del repo |
| Rollback a `SII_GATEWAY=fake` probado | ☑ Sí |

### Intento SLICE-37

| Resultado | Detalle |
|-----------|---------|
| `SII_GATEWAY=live` + `SII_AMBIENTE=cert` | Venta de prueba → `dteStatus` **EMITIDA** con folio |
| Asistencia UI | `sale_id` vía botón post-checkout (SLICE-35) |
| `ci-local.ps1` post-rollback | Verde (114 + 25 + 27) |

## Notas

- El campo **Venta `sale_id` local** se obtiene con **Copiar sale_id** en el diálogo post-checkout (pantalla Vender).
- Si el SII rechaza el XML, registrar `dteStatus` y mensaje en cola/logs locales.
- DoD piloto certificación: estado **CERRADO** en este archivo (SLICE-37).