# 20c — Revisión intermedia piloto operación UX

**Estado:** cerrada (slices 78–83, 2026-11-24)  
**Prerrequisito:** revisión 2 cerrada ([`20-plan-revision-2-atria-pos.md`](20-plan-revision-2-atria-pos.md), SLICE-77).  
**No sustituye revisión 3** ([`20b-esbozo-revision-3.md`](20b-esbozo-revision-3.md)).

## Objetivo

Cerrar fricciones detectadas en piloto manual de tienda (entradas, catálogo, etiquetas QR, sesión) antes de planificar R3 (SII/Kora).

## Alcance

| Incluye | Excluye |
|---------|---------|
| Ñ→N silenciosa en credenciales; RUT sin puntos con guión | Emisión SII / Kora |
| Lista stock + botón PRODUCTOS | Export código de barras (slice futuro) |
| PDF etiquetas QR | Cierre SLICE-50 BLE hardware |
| Cambiar sesión / expirada | Guía BLE en Vender (retirada; runbooks vigentes) |

**Paralelo:** SLICE-50 (piloto BLE) permanece **ABIERTO** sin bloquear esta revisión.

## Slices

| # | Slice | RF | DoD |
|---|-------|-----|-----|
| 78 | Entradas credenciales y RUT | RF-080 (amend) | Tests core + formatters UI |
| 79 | Stock productos + PRODUCTOS | RF-091 | `ListStoreProducts` + pantalla |
| 80 | Retiro piloto BLE UI | RNF-041 | Sin `scanner_pilot_guide` en Vender |
| 81 | Export QR PDF | RF-092, DEC-051 | PDF grilla 3×5 A4 |
| 82 | Sesión / cambiar usuario | RF-093, DEC-050 | Turno cerrado obligatorio |
| 83 | Cierre revisión intermedia | — | Acceptance + `ci-local` + commit |

## Gates

1. Tests verdes (`packages/core`, `apps/pos_app`).
2. Acceptance en `test/acceptance/slice_78_*.md` … `slice_83_*.md`.
3. Fila correspondiente en [`10-plan-entregas.md`](10-plan-entregas.md).
4. DEC-050/051 y RF actualizados en docs 04, 07, 16.

## Cierre

Al completar SLICE-83: marcar este documento **cerrada** y registrar §13 en acta [`19-revision-progreso-20251120.md`](19-revision-progreso-20251120.md).