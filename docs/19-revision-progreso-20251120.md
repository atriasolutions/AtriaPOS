# 19 — Acta de revisión post-tag MVP

**Fecha:** 2026-11-20  
**Alcance:** SLICE 44–47; estado tras tag `mvp-2026-11`  
**Repositorio remoto:** [mmb21894-ux/pos-barrio-segmento-d](https://github.com/mmb21894-ux/pos-barrio-segmento-d)  
**Acta anterior (histórica):** [`19-revision-progreso-20251119.md`](19-revision-progreso-20251119.md)

---

## 1. Verificación técnica

| Ítem | Esperado | Observado |
|------|----------|-----------|
| `origin/main` HEAD | Slices 44–46 integrados | `75a6f6f` (docs SLICE-46); merge código `ddd071e` ([PR #5](https://github.com/mmb21894-ux/pos-barrio-segmento-d/pull/5)) |
| Tag hito | `mvp-2026-11` publicado | Apunta a `ddd071e` (merge PR #5) |
| `ci-local.ps1` | 114 + 25 + 27 | Verde en sesión SLICE-46/47 |
| CI GitHub PR #5 | SUCCESS | `test` verde pre-merge |
| Acceptance Gherkin | Slices documentados | 44–46 + pendientes en `slice_46_mvp_tag.md` |
| Gate 2 DEC P0 004/005/011/012 | ✅ SLICE-45 | ADRs en `docs/decisiones/`; doc 17 **parcial** |

---

## 2. Slices cerrados desde acta 19-nov

| Slice | Entregable | Estado |
|-------|------------|--------|
| SLICE-44 | Handoff piloto BLE SC-011-BLE-01 | CERRADO documental; evidencia **PREPARADO** |
| SLICE-45 | ADRs DEC-004, 005, 011, 012 (+ 034) | CERRADO |
| SLICE-46 | PR #5 + tag `mvp-2026-11` | CERRADO |
| SLICE-47 | Acta post-tag (este documento) | CERRADO documental |

---

## 3. Matriz 12b — gaps vigentes

| ID | Estado | Acción |
|----|--------|--------|
| SC-011-BLE-01 | ⬜ | Piloto hardware; [`ble-scanner-pilot-evidence.md`](../runbooks/ble-scanner-pilot-evidence.md) |
| SC-080-03 | CERRADO | SLICE-37 |
| Gate 2 doc 17 | 🟡 | Parcial; ver § Retroactivo SLICE-45 |
| SLICE-9 / SII prod | N/A | Plan 10 |

---

## 4. Integración GitHub

- **PR #5:** MERGED — slices 44–45 en `main`.
- **Tag:** `mvp-2026-11` en remoto.
- **Ramas futuras:** desde `main` o checkout del tag para reproducir hito.

---

## 5. Deuda estratégica

| Riesgo | Severidad | Comentario |
|--------|-----------|------------|
| SC-011-BLE-01 manual | Baja | Único gap funcional manual destacado |
| Gate 2 abierto (checklist 17) | Media | DEC P0 MVP cerrados en SLICE-45; resto P1/P2 o checklist B–D |
| SII producción | Media | Fuera MVP demo |
| Ramas locales/obsoletas | Baja | Ver higiene en [`pr-merge-evidence.md`](../runbooks/pr-merge-evidence.md) |

---

## 6. Cola de trabajo sugerida

1. Piloto BLE con hardware → evidencia **CERRADO**.
2. Gate 2 completo o excepciones en [`11-riesgos-y-supuestos.md`](11-riesgos-y-supuestos.md).
3. Features negocio (impresión, backup, etc.) — nuevo slice bajo demanda.

---

## 7. DoD revisión 2026-11-20

- [x] `main` y tag documentados
- [x] Slices 44–46 trazados
- [x] Backlog explícito post-MVP
- [x] Acta publicada + reporte alineado (SLICE-47)