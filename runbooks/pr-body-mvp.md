## Summary

MVP POS barrio (segmento D): slices **0–8** (incl. DTE fake/replay/live en tests), **10–38** (+ **29–39** kit/evidencia merge en la rama); **SLICE-9** (terminal de pago) fuera de alcance.

- Tienda, usuarios y roles (PIN), turno y cierre de caja
- Venta, stock, anulaciones, catálogo, reportes y auditoría
- DTE **fake/replay** por defecto; consulta certificado SII (API-010); piloto cert **SC-080-03 CERRADO** (SLICE-37)
- Diagnóstico pruebas (SLICE-36), asistencia `sale_id` piloto SII (SLICE-33/35)
- Companion escáner BLE, hora SHOA, CI GitHub Actions

## Tests (paridad local = CI)

| Paquete | Tests |
|---------|-------|
| `packages/core` | 114 |
| `packages/adapters` | 25 |
| `apps/pos_app` | 27 |

Local: [`scripts/ci-local.ps1`](../scripts/ci-local.ps1) o [`runbooks/merge-mvp-hito.md`](merge-mvp-hito.md).

## Verificación

- Matriz: [`docs/12b-matriz-verificacion-automatizacion.md`](../docs/12b-matriz-verificacion-automatizacion.md)
- Reporte: [`docs/reporte-avances-mvp.md`](../docs/reporte-avances-mvp.md)
- Aceptación: `test/acceptance/slice_*.md` (0–38)
- Diagnóstico: [`docs/18-diagnostico-pruebas.md`](../docs/18-diagnostico-pruebas.md)

## Operación piloto

Ruta unificada en tienda: [`runbooks/tienda-piloto-indice.md`](tienda-piloto-indice.md) (evidencia [`tienda-piloto-evidencia.md`](tienda-piloto-evidencia.md)).

## Pendiente post-merge (no bloquea este PR)

- Piloto BLE real **SC-011-BLE-01** — [`runbooks/ble-piloto-indice.md`](ble-piloto-indice.md)
- Producción fiscal (`SII_AMBIENTE=prod`) fuera de MVP

## Tras abrir el PR

Registrar metadatos (URL, CI) en [`runbooks/pr-merge-evidence.md`](pr-merge-evidence.md). Título sugerido: `MVP POS: slices 0-38`.

## CI

Workflow `CI` en push/PR a `main` y `feat/**` (`.github/workflows/ci.yml`).