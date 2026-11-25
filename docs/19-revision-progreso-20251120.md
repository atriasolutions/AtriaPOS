# 19 — Acta de revisión post-tag MVP

**Fecha:** 2026-11-20  
**Alcance:** SLICE 44–51; estado tras tag `mvp-2026-11` (revisión SLICE-51 backlog; SLICE-50 ABIERTO)  
**Repositorio histórico (archivado):** [mmb21894-ux/pos-barrio-segmento-d](https://github.com/mmb21894-ux/pos-barrio-segmento-d) — PR #1–#11 y merges MVP.  
**Acta anterior (histórica):** [`19-revision-progreso-20251119.md`](19-revision-progreso-20251119.md)

### Repositorio canónico (SLICE-55)

| Campo | Valor |
|-------|-------|
| Repo | [atriasolutions/AtriaPOS](https://github.com/atriasolutions/AtriaPOS) (privado) |
| Corte org | 2026-11-24 — SLICE-58 |
| Marca | **Atria POS** |
| DEC | [DEC-044](decisiones/DEC-044-marca-atria-pos.md), [DEC-046](decisiones/DEC-046-repo-org-atriasolutions.md) |
| Intermedio archivado | [mmb21894-ux/atria-pos](https://github.com/mmb21894-ux/atria-pos) |
| Migración | [`runbooks/repo-migracion-atria-pos.md`](../runbooks/repo-migracion-atria-pos.md) § SLICE-58 |

---

## 1. Verificación técnica

| Ítem | Esperado | Observado |
|------|----------|-----------|
| `origin/main` HEAD | Slices 52–54 revisión 1 | `248fbbb` ([PR #10](https://github.com/mmb21894-ux/pos-barrio-segmento-d/pull/10)); histórico `39cb13e` (SLICE-51); tag `mvp-2026-11` → `ddd071e` |
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
| SLICE-52 | Central BLE Windows | CERRADO — [PR #10](https://github.com/mmb21894-ux/pos-barrio-segmento-d/pull/10) MERGED → `main` `248fbbb` |
| SLICE-53 | Piloto tienda demo fake | CERRADO — evidencia agregada **PARCIAL**; BLE pendiente |
| SLICE-54 | Cierre revisión 1 | CERRADO — merge PR #10; acta §10; evidencia operador 2026-11-24 |

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

**Objetivo:** núcleo MVP tienda (DTE fake) validado en piloto; código 52–53 integrado en `main`; Bluetooth evidencia (SLICE-50) **paralelo** al plan revisión 2 (doc 20).

| Ítem | Estado |
|------|--------|
| Demo fake (fecha/operador en evidencia) | CERRADO |
| Evidencia agregada `tienda-piloto-evidencia` | **PARCIAL** (BLE no exigido en rev. 1) |
| SLICE-52–54 en `origin/main` | **CERRADO** — [PR #10](https://github.com/mmb21894-ux/pos-barrio-segmento-d/pull/10) → `248fbbb` |
| SLICE-50 / SC-011-BLE-01 | **ABIERTO** |

### DoD revisión 1

- [x] Piloto tienda núcleo exitoso (operador)
- [x] SC-028-03 cerrado documental (evidencia PARCIAL)
- [x] Fecha y operador en [`tienda-piloto-evidencia.md`](../runbooks/tienda-piloto-evidencia.md)
- [x] `origin/main` integra SLICE-52–54 (`248fbbb`, PR #10)
- [x] Handoff revisión 2: plan [`20-plan-revision-2-atria-pos.md`](20-plan-revision-2-atria-pos.md) (SLICE-50 no bloquea Gate R2)

---

## 11. Handoff → revisión 2 (plan documental)

| Ítem | Detalle |
|------|---------|
| Plan maestro | [`20-plan-revision-2-atria-pos.md`](20-plan-revision-2-atria-pos.md) — plantilla **Atria POS**, R2-A estructural, R2-B UI |
| Gate siguiente | **SLICE-59** (Gate R2); código R2 desde **SLICE-60** |
| Cola slices | [`10-plan-entregas.md`](10-plan-entregas.md) § Revisión 2 |
| Revisión 3 (stub) | [`20b-esbozo-revision-3.md`](20b-esbozo-revision-3.md) — SII vía Kora, fuera de R2 |
| Deuda paralela | SLICE-50 BLE ABIERTO (no prerequisito Gate R2) |

**Estado handoff §11:** revisión 2 **cerrada** (SLICE-77). Planificación siguiente: [`20b-esbozo-revision-3.md`](20b-esbozo-revision-3.md).

---

## 12. Cierre revisión 2 (SLICE-77)

**Objetivo:** cola SLICE-59…76 en `main` local integrada en `origin/main`; documentación y CI alineados. BLE (SLICE-50) **no bloquea** este cierre.

| Ítem | Estado |
|------|--------|
| Slices R2-A 60–69 en `main` | CERRADO |
| Slices R2-B 70–76 en `main` | CERRADO |
| `scripts/ci-local.ps1` en commit cierre | CERRADO |
| Push directo `origin/main` (atriasolutions/AtriaPOS) | CERRADO — `origin/main` `f5eba61` ([`pr-merge-evidence.md`](../runbooks/pr-merge-evidence.md) § SLICE-77) |
| SLICE-50 / SC-011-BLE-01 hardware | **ABIERTO** |

### DoD revisión 2

- [x] Plan [`20-plan-revision-2-atria-pos.md`](20-plan-revision-2-atria-pos.md) con estado R2 cerrada
- [x] Fila SLICE-59…76 ✅ en [`10-plan-entregas.md`](10-plan-entregas.md)
- [x] Acceptance [`slice_77_revision_2_cierre.md`](../test/acceptance/slice_77_revision_2_cierre.md)
- [x] `ci-local.ps1` verde antes del push
- [x] SLICE-50 documentado ABIERTO (sin cierre falso)

---

## 13. Revisión intermedia piloto UX (SLICE-78…83)

**Inicio:** 2026-11-24 — programa [`20c-plan-revision-intermedia-operacion.md`](20c-plan-revision-intermedia-operacion.md).

| Ítem | Estado |
|------|--------|
| SLICE-78…82 producto | CERRADO |
| SLICE-83 cierre documental | CERRADO |
| `ci-local.ps1` | CERRADO |
| SLICE-50 BLE hardware | **ABIERTO** (sin bloqueo) |

---

## 14. Bloque A — operación y productos (Gate R4-A)

**Inicio:** 2026-11-25 — plan [`21-plan-revision-operacion-productos.md`](21-plan-revision-operacion-productos.md); respuestas [`23-gate-r4-a-respuestas.md`](23-gate-r4-a-respuestas.md).  
**Cierre Bloque A:** 2026-11-25 — SLICE-94; acceptance [`slice_94_cierre_bloque_a.md`](../test/acceptance/slice_94_cierre_bloque_a.md).

| Ítem | Estado |
|------|--------|
| Gate R4-A (DEC-052…055) | CERRADO documental |
| SLICE-85 contrato `ScanSession` | CERRADO — `slice_85_scan_session.md` |
| SLICE-86 confirm ingreso scan | CERRADO — `slice_86_confirm_receipt_scan.md` |
| SLICE-87 UI ingreso scan | CERRADO — `slice_87_stock_receipt_scan_ui.md` |
| SLICE-88 conteo scan core | CERRADO — `slice_88_conteo_escaneo_core.md` |
| SLICE-89 UI conteo scan | CERRADO — `slice_89_conteo_escaneo_ui.md` |
| SLICE-90 cambio producto core | CERRADO — `slice_90_cambio_producto_core.md` |
| SLICE-91 cambio mostrador UI | CERRADO — `slice_91_cambio_producto_ui.md` |
| SLICE-92 nota de crédito | CERRADO — `slice_92_nota_credito.md` |
| SLICE-93 factura checkout | CERRADO — `slice_93_factura.md` |
| SLICE-94 cierre Bloque A | CERRADO — `slice_94_cierre_bloque_a.md` |
| `ci-local.ps1` Bloque A | CERRADO (ver SC-094-01) |
| SLICE-50 BLE hardware | **ABIERTO** (sin bloqueo de programa) |
| Gate 23 ítems `[REVISAR]` | **ABIERTO** anotado — no bloquea cierre |
| Bloque B companion web | stub — **planificación por slices habilitada** (doc 22) |

### DoD cierre Bloque A (SLICE-94)

- [x] Acceptance [`slice_94_cierre_bloque_a.md`](../test/acceptance/slice_94_cierre_bloque_a.md)
- [x] `scripts/ci-local.ps1` verde antes del commit de cierre
- [x] Commit `feat(slice-94): cierre revision operacion productos.`
- [x] Doc 21 cerrado; doc 10 filas 85–94 ✅

---

## 15. Bloque B — companion web WiFi (Gate R4-B)

**Inicio:** 2026-11-25 — plan [`22-plan-companion-web.md`](22-plan-companion-web.md); respuestas [`23b-gate-r4-b-respuestas.md`](23b-gate-r4-b-respuestas.md).

| Ítem | Estado |
|------|--------|
| Gate R4-B (DEC-056…058) | CERRADO documental |
| SLICE-95 gate docs | CERRADO |
| SLICE-96 emparejamiento | CERRADO — `slice_96_companion_pairing.md` |
| SLICE-97–98 servidor LAN | CERRADO — `slice_97_98_lan_server.md` |
| SLICE-99 QR POS | CERRADO — `slice_99_pos_qr.md` |
| SLICE-100 PWA | CERRADO — `slice_100_companion_web.md` |
| SLICE-101–103 E2E | CERRADO — `slice_101_103_companion_e2e.md` |
| SLICE-104 BLE legacy default | CERRADO — `slice_104_ble_deprecation.md` |
| SLICE-105 cierre Bloque B | CERRADO — `slice_105_cierre_bloque_b.md` |
| BLE companion piloto hardware | **LEGACY** (opt-in `lanCompanionDefault=false`) |

**Cierre Bloque B:** 2026-11-25 — SLICE-105; acceptance `slice_105_cierre_bloque_b.md`.  
**Tanda HTTPS:** SLICE-106 guarda DEC-059…062 ([23c](23c-companion-https-respuestas.md)). Slices 107–112 pendientes, cada uno en Plan antes de Agent.

### DoD cierre Bloque B (SLICE-105)

- [x] Acceptance slices 96–105 + `slice_105_cierre_bloque_b.md`
- [x] `scripts/ci-local.ps1` verde
- [x] Doc 22 cerrado; doc 10 filas 95–105 ✅

---

## 7. DoD revisión 2026-11-20

- [x] `main` y tag documentados
- [x] Slices 44–46 trazados
- [x] Backlog explícito post-MVP
- [x] Acta publicada + reporte alineado (SLICE-47)
- [x] SLICE-49: `origin/main` alineado con PR #6/#7 y evidencia actualizada
- [x] SLICE-51: backlog explícito; SLICE-50 ABIERTO sin cierre falso de evidencia