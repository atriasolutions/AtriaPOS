# 19 — Acta de revisión de progreso MVP

**Fecha:** 2026-11-19  
**Alcance:** SLICE 0–8, 10–41; revisión integral post-registro PR  
**Repositorio remoto:** [mmb21894-ux/pos-barrio-segmento-d](https://github.com/mmb21894-ux/pos-barrio-segmento-d)

---

## 1. Verificación técnica (Fase 1)

| Ítem | Esperado | Observado |
|------|----------|-----------|
| `origin` | Configurado | `https://github.com/mmb21894-ux/pos-barrio-segmento-d.git` |
| HEAD local (rama feature) | `22ddccc` | `22ddccc` — `feat(slice-41): evidencia PR ABIERTO SC-030-01.` |
| `origin/main` post-merge PR #1 | MERGED | `20dad83` (2026-11-19T20:34:50Z) |
| Acta en `main` | PR #2 | [pull/2](https://github.com/mmb21894-ux/pos-barrio-segmento-d/pull/2) — merge pendiente; commit `5b5339f` en remoto `feat/slice-0-scaffold` |
| `ci-local.ps1` | 114 + 25 + 27 | Verde (2026-11-19, sesión revisión) |
| PR #1 estado | ABIERTO o MERGED | **MERGED** — [pull/1](https://github.com/mmb21894-ux/pos-barrio-segmento-d/pull/1) |
| CI GitHub | SUCCESS | `CI / test` (pull_request y push), conclusión SUCCESS |
| Cobertura core | ~81 % ([`18`](18-diagnostico-pruebas.md)) | Sin re-medición en este turno; baseline SLICE-36 vigente |

---

## 2. Producto y requisitos [M] (Fase 2)

Todos los RF **[M]** de [`04-requisitos-funcionales.md`](04-requisitos-funcionales.md) (RF-001 … RF-070) figuran **✅** o **🔶** en [`reporte-avances-mvp.md`](reporte-avances-mvp.md) §3.

| RF | Estado revisión | Nota |
|----|-----------------|------|
| RF-001 … RF-041, RF-051, RF-060, RF-070 | ✅ | Tests core/adapters/app |
| RF-003 | ✅ | API-010 + piloto cert **CERRADO** |
| RF-050 | 🔶 | Fake/replay/live en CI; **producción SII** fuera MVP demo |
| APIs API-001 … API-010 | Sin TBD | [`07-contratos-api-publica.md`](07-contratos-api-publica.md) |
| Acceptance Gherkin | 40 archivos | `test/acceptance/slice_*.md` (sin slice-9 opcional) |

---

## 3. Matriz 12b — gaps (Fase 3)

| ID | Estado | Acción |
|----|--------|--------|
| SC-030-01 | ✅ | PR registrado |
| SC-030-02 | ✅ | HEAD/rama/merge alineados en [`pr-merge-evidence.md`](../runbooks/pr-merge-evidence.md) |
| SC-011-BLE-01 | ⬜ | Piloto manual BLE — único gap funcional manual destacado |
| SC-080-03 | CERRADO | [`sii-cert-pilot-evidence.md`](../runbooks/sii-cert-pilot-evidence.md) (SLICE-37) |
| SC-030-xx / SC-03x-00 (docs) | — | Trazabilidad slices 30–41; sin bloqueo |

---

## 4. Integración GitHub (Fase 4)

- **SLICE-41:** evidencia PR ABIERTO → actualizado.
- **SLICE-42 (parcial en esta revisión):** operador mergeó PR #1; evidencia documental **MERGED**.
- **Rama default remota:** `main` en `20dad83`.
- **Tag hito:** no aplicado (opcional `mvp-2026-11` pendiente decisión).

---

## 5. Deuda estratégica (Fase 5)

| Riesgo | Severidad | Comentario |
|--------|-----------|------------|
| Gate 2 abierto | Media | [`17-cierre-gate-2.md`](17-cierre-gate-2.md); DEC P0 ⬜ en [`16`](16-registro-decisiones.md) (DEC-004, 005, 011, 012…) — no bloquea operación demo |
| SII producción | Media | Requiere `SII_AMBIENTE=prod`, certificado y folios reales |
| SC-011-BLE-01 manual | Baja | Prep UI/tests OK; piloto hardware pendiente |
| SLICE-9 terminal pago | Baja | Opcional; sin iniciar |
| Kora / complementos | Baja | Núcleo autónomo según [`14`](14-nucleo-y-complementos-kora.md) |

---

## 6. Cola de trabajo priorizada

1. **Operación post-merge:** `git checkout main && git pull` en clones locales; alinear ramas de feature futuras desde `main`.
2. **Piloto BLE** — cerrar SC-011-BLE-01 en evidencia.
3. **Gate 2** — cerrar DEC P0 restantes o registrar excepciones explícitas.
4. **SLICE-9 / prod SII** — solo si negocio lo prioriza.

---

## 7. DoD revisión

- [x] `ci-local.ps1` verde y CI GitHub PR #1 SUCCESS
- [x] Tabla brechas (técnica, producto, manual, documental)
- [x] RF **[M]** mapeados
- [x] Evidencia PR **MERGED** + CI ☑
- [x] Acta (este documento) + reporte actualizado

---

## 8. Backlog post-MVP (no bloquea próximo slice de producto)

| ID propuesto | Tema | Disparador |
|--------------|------|------------|
| SLICE-44 | Piloto BLE SC-011-BLE-01 | Hardware; [`ble-scanner-pilot-evidence.md`](../runbooks/ble-scanner-pilot-evidence.md) |
| SLICE-45 | Gate 2 DEC P0 retroactivos (004, 005, 011, 012) | Antes de slice que cambie checkout/contratos |
| SLICE-46 | Tag `mvp-2026-11` | Tras `main` estable con acta (post PR #2) |
| SLICE-9 | Terminal de pago | **N/A** — diferido; ver plan 10 |
| SII `prod` | Producción fiscal | **N/A** — fuera MVP; cert SC-080-03 cerrado |

**Gate SLICE-43:** merge [PR #2](https://github.com/mmb21894-ux/pos-barrio-segmento-d/pull/2) → `git checkout main && git pull`.