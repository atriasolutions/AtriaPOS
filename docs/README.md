# Documentación — Atria POS (segmento D, almacén de barrio)

Índice de definición previa al desarrollo.

**Gates:** [Gate 1](12-cierre-gate-1.md) ✅ → [Plan definición](15-plan-definicion-pre-implementacion.md) → [Gate 2](17-cierre-gate-2.md) antes de SLICE-1 TDD → **revisión 2** ✅ (SLICE-59…77, acta [19](19-revision-progreso-20251120.md) §12) → **revisión intermedia UX** ([20c](20c-plan-revision-intermedia-operacion.md), SLICE-78…83) → **revisión 3:** [20b](20b-esbozo-revision-3.md).

| # | Documento | Propósito |
|---|-----------|-----------|
| 00 | [Contexto y alcance](00-contexto-y-alcance.md) | Problema, usuarios, límites del producto |
| 01 | [Perfil segmento D](01-perfil-segmento-d.md) | Benchmark y propuesta de valor |
| 02 | [Visión y principios](02-vision-y-principios.md) | Norte del producto y decisiones de diseño |
| 03 | [Dominio y glosario](03-dominio-y-glosario.md) | Ubiquitous language |
| 04 | [Requisitos funcionales](04-requisitos-funcionales.md) | RF numerados + criterios de aceptación |
| 05 | [Requisitos no funcionales](05-requisitos-no-funcionales.md) | RNF, seguridad, SII, offline |
| 06 | [Arquitectura](06-arquitectura.md) | Capas, bounded contexts, stack propuesto |
| 07 | [Contratos API pública](07-contratos-api-publica.md) | Superficie bajo prueba (TDD) |
| 08 | [Modelo de datos conceptual](08-modelo-datos-conceptual.md) | Entidades y relaciones |
| 09 | [Estrategia TDD](09-estrategia-tdd.md) | Vertical slices, pruebas de comportamiento |
| 10 | [Plan de entregas](10-plan-entregas.md) | Orden de slices y definición de hecho |
| 11 | [Riesgos y supuestos](11-riesgos-y-supuestos.md) | Etiquetas OBSERVADO / INFERIDO / ESPECULATIVO |
| 12 | [Cierre Gate 1](12-cierre-gate-1.md) | Checklist de confirmación antes de codear |
| 13 | [Mapeo documentación](13-mapeo-documentacion.md) | Inventario, dependencias, RF↔API↔slice |
| 14 | [Núcleo y complementos Kora](14-nucleo-y-complementos-kora.md) | POS autónomo; Kora opcional |
| 15 | [Plan definición pre-impl.](15-plan-definicion-pre-implementacion.md) | Fases 0–7, workshops, Gate 2 |
| 16 | [Registro decisiones DEC](16-registro-decisiones.md) | 40 decisiones P0–P3 |
| 17 | [Cierre Gate 2](17-cierre-gate-2.md) | Autorización SLICE-1+ |
| 18 | [Diagnóstico pruebas](18-diagnostico-pruebas.md) | Baseline suites, cobertura core, foco pre-slice |
| 19 | [Revisión progreso post-tag 2026-11-20](19-revision-progreso-20251120.md) | Acta vigente — R2 cerrada SLICE-77; SLICE-50 BLE ABIERTO |
| 19 (hist.) | [Revisión progreso 2025-11-19](19-revision-progreso-20251119.md) | Acta MVP merge PR #1/#2 (histórica) |
| 20 | [Plan revisión 2 Atria POS](20-plan-revision-2-atria-pos.md) | R2 cerrada — SLICE-59…76 producto; SLICE-77 cierre |
| 20c | [Revisión intermedia piloto UX](20c-plan-revision-intermedia-operacion.md) | Post-R2, pre-R3 |
| 20b | [Esbozo revisión 3 SII/Kora](20b-esbozo-revision-3.md) | Fuera de alcance R2 |
| 08b | [Esquema SQLite v1 borrador](08b-esquema-sqlite-v1.md) | DDL pendiente Gate 2 |
| — | [ADRs](decisiones/README.md) | Plantilla decisiones |

## Convención de edición

- Idioma: español Chile.
- Criterios de aceptación: formato **Dado / Cuando / Entonces**.
- IDs estables: `RF-xxx`, `RNF-xxx`, `API-xxx`, `SLICE-xxx`.