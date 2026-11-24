# 19 — Acta de revisión post-tag MVP

**Fecha:** 2026-11-20  
**Alcance:** SLICE 44–51; estado tras tag `mvp-2026-11` (revisión SLICE-51 backlog; SLICE-50 ABIERTO)  
**Repositorio remoto:** [mmb21894-ux/pos-barrio-segmento-d](https://github.com/mmb21894-ux/pos-barrio-segmento-d)  
**Acta anterior (histórica):** [`19-revision-progreso-20251119.md`](19-revision-progreso-20251119.md)

---

## 1. Verificación técnica

| Ítem | Esperado | Observado |
|------|----------|-----------|
| `origin/main` HEAD | Slices 44–49 docs integrados | `2f10165` ([PR #8](https://github.com/mmb21894-ux/pos-barrio-segmento-d/pull/8)); código BLE via PR #7 `c5a1fda`; merge histórico `ddd071e` ([PR #5](https://github.com/mmb21894-ux/pos-barrio-segmento-d/pull/5)) |
| Tag hito | `mvp-2026-11` publicado | Apunta a `ddd071e` (sin mover) |
| `ci-local.ps1` | 114 + 25 + 27 + 1 | Verde SLICE-48/49/51 (`scanner_companion`) |
| CI GitHub PR #6–#8 | SUCCESS | `test` verde pre-merge |
| Acceptance Gherkin | Slices documentados | hasta `slice_51_acta_backlog.md` |
| Gate 2 DEC P0 004/005/011/012 | ✅ SLICE-45 | ADRs en `docs/decisiones/`; doc 17 **parcial** |

---

## 2. Slices cerrados desde acta 19-nov

| Slice | Entregable | Estado |
|-------|------------|--------|
| SLICE-44 | Handoff piloto BLE SC-011-BLE-01 | CERRADO documental; evidencia **PREPARADO** |
| SLICE-45 | ADRs DEC-004, 005, 011, 012 (+ 034) | CERRADO |
| SLICE-46 | PR #5 + tag `mvp-2026-11` | CERRADO |
| SLICE-47 | Acta post-tag | CERRADO — [PR #6](https://github.com/mmb21894-ux/pos-barrio-segmento-d/pull/6) MERGED |
| SLICE-48 | Pre-piloto BLE + companion CI | CERRADO — [PR #7](https://github.com/mmb21894-ux/pos-barrio-segmento-d/pull/7) MERGED |
| SLICE-49 | Integración `main` 47–48 + evidencia | CERRADO — [PR #8](https://github.com/mmb21894-ux/pos-barrio-segmento-d/pull/8) MERGED |
| SLICE-50 | Piloto BLE evidencia SC-011-BLE-01 | **ABIERTO** — prep/ci-local; guía [`ble-piloto-dia-cero.md`](../runbooks/ble-piloto-dia-cero.md); evidencia **PREPARADO** |
| SLICE-51 | Acta backlog (piloto diferido) | CERRADO documental |
| SLICE-52 | Central BLE Windows | CERRADO — rama `feat/slice-53-tienda-piloto-cierre` (incluye 52); merge `main` vía PR pendiente |
| SLICE-53 | Piloto tienda demo fake | CERRADO — evidencia agregada **PARCIAL**; BLE pendiente |

---

## 3. Matriz 12b — gaps vigentes

| ID | Estado | Acción |
|----|--------|--------|
| SC-011-BLE-01 | ⬜ | **SLICE-50 ABIERTO** — piloto hardware diferido; [`ble-scanner-pilot-evidence.md`](../runbooks/ble-scanner-pilot-evidence.md) **PREPARADO** |
| SC-028-03 | CERRADO | SLICE-53 — demo fake tienda; [`tienda-piloto-evidencia.md`](../runbooks/tienda-piloto-evidencia.md) **PARCIAL** |
| SC-080-03 | CERRADO | SLICE-37 |
| Gate 2 doc 17 | 🟡 | Parcial; ver § Retroactivo SLICE-45 |
| SLICE-9 / SII prod | N/A | Plan 10 |

---

## 4. Integración GitHub

- **PR #5:** MERGED — slices 44–45 en `main`.
- **PR #6–#8:** MERGED — slices 47–49 en `main` (`2f10165`).
- **Tag:** `mvp-2026-11` en remoto (`ddd071e`).
- **Ramas futuras:** `git checkout main && git pull` → `feat/slice-N-...`.

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

1. **SLICE-50** — piloto BLE en hardware cuando disponible → [`ble-piloto-dia-cero.md`](../runbooks/ble-piloto-dia-cero.md) → evidencia **CERRADO** (requiere `main` con SLICE-52).
2. Smoke SC-052-03 en hardware (aceptance SLICE-52).
3. Gate 2 completo o excepciones en [`11-riesgos-y-supuestos.md`](11-riesgos-y-supuestos.md).
4. Features negocio (impresión, backup, etc.) — slice bajo demanda.

---

## 8. Backlog revisado (SLICE-51)

| ID | Estado | Disparador |
|----|--------|------------|
| SLICE-50 | ABIERTO | Hardware; operador cierra SC-011-BLE-01 |
| SLICE-51 | CERRADO | Acta/backlog al día con `main` `2f10165` |
| SLICE-52 | CERRADO | Central BLE Windows; PR a `main` pendiente |
| SLICE-53 | CERRADO | Demo tienda fake; evidencia **PARCIAL** |
| SLICE-9 / SII prod | N/A | Plan 10 |

---

## 9. Revisión 2026-11-24 (SLICE-52 / SLICE-53)

- Piloto tienda núcleo (DTE fake) **exitoso** en operación — registrado en [`tienda-piloto-evidencia.md`](../runbooks/tienda-piloto-evidencia.md) **PARCIAL**.
- SLICE-52: fix central BLE Windows en rama de entrega; smoke hardware **pendiente**.
- SLICE-50 / SC-011-BLE-01 **sin cierre** hasta sesión BLE formal.
- Merge a `origin/main`: PR con rama `feat/slice-53-tienda-piloto-cierre` (SLICE-52–54) — ver §10.

---

## 10. Cierre revisión 1 (SLICE-54)

**Objetivo:** núcleo MVP tienda (DTE fake) validado en piloto; código 52–53 integrado en `main`; Bluetooth formal diferido a revisión 2 (SLICE-50).

| Ítem | Estado |
|------|--------|
| Demo fake (fecha/operador en evidencia) | CERRADO |
| Evidencia agregada `tienda-piloto-evidencia` | **PARCIAL** (BLE no exigido en rev. 1) |
| SLICE-52 / SLICE-53 en `origin/main` | _(actualizar post-merge con PR y HEAD)_ |
| SLICE-50 / SC-011-BLE-01 | **ABIERTO** |

### DoD revisión 1

- [x] Piloto tienda núcleo exitoso (operador)
- [x] SC-028-03 cerrado documental (evidencia PARCIAL)
- [x] Fecha y operador en [`tienda-piloto-evidencia.md`](../runbooks/tienda-piloto-evidencia.md)
- [ ] `origin/main` integra SLICE-52–54 _(completar al merge)_
- [x] Revisión 2 explícita: SLICE-50 BLE + smoke SC-052-03

---

## 7. DoD revisión 2026-11-20

- [x] `main` y tag documentados
- [x] Slices 44–46 trazados
- [x] Backlog explícito post-MVP
- [x] Acta publicada + reporte alineado (SLICE-47)
- [x] SLICE-49: `origin/main` alineado con PR #6/#7 y evidencia actualizada
- [x] SLICE-51: backlog explícito; SLICE-50 ABIERTO sin cierre falso de evidencia