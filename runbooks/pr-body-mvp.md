## Summary

MVP POS barrio (segmento D): slices **0–8** (incl. DTE fake/replay/live en tests), **10–28** (+ **29** alineación merge en la rama); **SLICE-9** (terminal de pago) fuera de alcance.

- Tienda, usuarios y roles (PIN), turno y cierre de caja
- Venta, stock, anulaciones, catálogo, reportes y auditoría
- DTE **fake/replay** por defecto; consulta certificado SII (API-010) y guía prep piloto (SLICE-25)
- Companion escáner BLE, hora SHOA, CI GitHub Actions

## Tests (paridad local = CI)

| Paquete | Tests |
|---------|-------|
| `packages/core` | 114 |
| `packages/adapters` | 25 |
| `apps/pos_app` | 26 |

Local: [`scripts/ci-local.ps1`](../scripts/ci-local.ps1) o [`runbooks/merge-mvp-hito.md`](merge-mvp-hito.md).

## Verificación

- Matriz: [`docs/12b-matriz-verificacion-automatizacion.md`](../docs/12b-matriz-verificacion-automatizacion.md)
- Reporte: [`docs/reporte-avances-mvp.md`](../docs/reporte-avances-mvp.md)
- Aceptación: `test/acceptance/slice_*.md` (0–29)

## Operación piloto

Ruta unificada en tienda: [`runbooks/tienda-piloto-indice.md`](tienda-piloto-indice.md) (evidencia [`tienda-piloto-evidencia.md`](tienda-piloto-evidencia.md)).

## Pendiente post-merge (no bloquea este PR)

- Piloto certificación SII **SC-080-03** manual — [`runbooks/sii-piloto-indice.md`](sii-piloto-indice.md) y [`sii-cert-pilot-evidence.md`](sii-cert-pilot-evidence.md)
- Producción fiscal hasta evidencia **CERRADO**

## Tras abrir el PR

Registrar metadatos (URL, CI) en [`runbooks/pr-merge-evidence.md`](pr-merge-evidence.md). Título sugerido: `MVP POS: slices 0-28` _(actualizar al cerrar slices nuevos)_.

## CI

Workflow `CI` en push/PR a `main` y `feat/**` (`.github/workflows/ci.yml`).