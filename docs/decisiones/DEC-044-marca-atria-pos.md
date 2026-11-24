# DEC-044 — Marca Atria POS y repositorio canónico

**Estado:** ✅ Decidido (2026-11-24)  
**Slice:** SLICE-55 (Fase A) / SLICE-56 (Fase B)

## Decisión

1. **Nombre comercial:** **Atria POS** (Atria Solutions SpA).
2. **Perfil mercado:** se mantiene **segmento D** en RF y doc `01`; no forma parte del slug git.
3. **Repositorio canónico:** `https://github.com/mmb21894-ux/atria-pos` (privado).
4. **Repositorio histórico:** `mmb21894-ux/pos-barrio-segmento-d` — archivado; enlaces a PRs históricos **no se reescriben** en actas/CHANGELOG; se añade bloque “Repositorio canónico” en acta vigente.
5. **Fase B (SLICE-56):** `kAppName`, prefijo BLE `Atria-POS`, barrel `atria_pos_core.dart`, política BD legada (ver abajo).

## Política base de datos local (Fase B)

| Situación | Comportamiento |
|-----------|----------------|
| Existe `pos_barrio.sqlite` | Seguir usándolo (sin copia automática). |
| Instalación nueva | Crear `atria_pos.sqlite`. |

Evita migración de datos en piloto; instalaciones nuevas llevan nombre alineado a marca.

## Política BLE (Fase B)

Prefijo GAP: `Atria-POS-{código}` (reemplaza `POS-Barrio-`). Requiere **rebuild** companion y re-pareo (coordinar con SLICE-50).

## Alternativas descartadas

- Renombrar paquetes pub `core` / `pos_app` en la misma entrega — riesgo/alto diff sin valor inmediato.
- Reescribir URLs de PR #1–#11 — pierde trazabilidad de revisión.

## Impacto

- README, AGENTS, reporte, runbooks migración y remoto.
- SLICE-56: código en `packages/core`, `apps/pos_app`, `scanner_companion`.