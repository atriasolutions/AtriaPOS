# Reporte de avances — Sistema POS segmento D

**Proyecto:** POS barrio (Chile), núcleo local-first  
**Fecha de reporte:** 2026-11-19 (revisión integral — [`19-revision-progreso-20251119.md`](19-revision-progreso-20251119.md))  
**Rama estable:** `main` en remoto (`20dad83`, merge PR #1); desarrollo local puede seguir en `feat/slice-0-scaffold`  
**Repositorio:** [github.com/mmb21894-ux/pos-barrio-segmento-d](https://github.com/mmb21894-ux/pos-barrio-segmento-d)  
**Organización:** Atria Solutions SpA  

---

## 1. Resumen ejecutivo

El producto cuenta con un **MVP vertical implementado en código** desde SLICE-0 hasta **SLICE-37** (piloto certificación SII SC-080-03 cerrado en evidencia), con **MVP integrado en `main`** vía [PR #1](https://github.com/mmb21894-ux/pos-barrio-segmento-d/pull/1) (MERGED), arquitectura Flutter + dominio Dart (`packages/core`) y persistencia Drift (`packages/adapters`). La operación diaria de una tienda piloto es **demostrable en app**: alta de tienda, usuarios, login por PIN, turno, venta con stock, DTE fake/replay y **emisión live en cert** validada en operación, cierre de caja, anulaciones, ajuste de stock, catálogo, reportes, auditoría, consulta de certificado, escáner companion (BLE) y hora SHOA.

| Indicador | Valor [OBSERVADO] |
|-----------|-------------------|
| Slices cerrados (plan 10) | 0–8, 10–29 + **30–43** (43 = alinear main, PR #2); **9** N/A diferido |
| Contratos API publicados | API-001 … API-010 (`docs/07-contratos-api-publica.md`) |
| Escenarios acceptance | 41 archivos `test/acceptance/slice_*.md` |
| Tests automatizados | Core **114**, adapters **25**, app **27** (widget/e2e); cobertura core **81,2 %** ([`18-diagnostico-pruebas.md`](18-diagnostico-pruebas.md)) |
| CI | GitHub Actions: core + adapters + `flutter test` (`.github/workflows/ci.yml`) |
| Merge a `main` | `main` @ `6032997` — [PR #1](https://github.com/mmb21894-ux/pos-barrio-segmento-d/pull/1) + [PR #2](https://github.com/mmb21894-ux/pos-barrio-segmento-d/pull/2) MERGED |
| Ruta tienda piloto | [`runbooks/tienda-piloto-indice.md`](../runbooks/tienda-piloto-indice.md); evidencia agregada PREPARADO por defecto |
| Piloto SII real | **SC-080-03 CERRADO** (SLICE-37); folio/`sale_id` en bitácora local; demo con `SII_GATEWAY=fake` |

**Lectura de madurez:** listo para **piloto operativo en tienda** con certificación SII ejecutada en ambiente cert; producción fiscal (`SII_AMBIENTE=prod`) sigue fuera de MVP.

---

## 2. Entregas por slice (evidencia en Git)

| Slice | Commit representativo | RF principal | Evidencia técnica |
|-------|------------------------|--------------|-------------------|
| 0 | `b7b483b` | Scaffold | Monorepo, smoke tests |
| 1 | (inicial) | RF-010, RF-011 | `ProductService`, SC-010/011 |
| 2 | (inicial) | RF-020, RF-021 | `InventoryService`, drift movimientos |
| 3 | (inicial) | RF-030, RF-031 | `SaleService`, checkout |
| 4 | (inicial) | RF-040, RF-041 | `ShiftService`, cierre |
| 5 | (inicial) | RF-050, RF-051 | DTE fake, cola |
| 6 | (inicial) | RF-030 UI | App Flutter venta |
| 7 | (inicial) | RF-002 | `AuthService`, permisos |
| 8 | `5d54d62` | RF-003, RF-050 real | SII live/replay, runbooks |
| 10 | `ff4ac47`, `78c9613` | RF-032 | Anulación + UI turno |
| 11 | `baaf7b3` | RF-041, RF-051, RF-021 UI | Menú operación, CI, `12b` |
| 12 | `ba60e09` | RF-001 | Bootstrap tienda, onboarding |
| 13 | `4387509` | RF-010 UI | Crear producto en app |
| 14 | `7149a7f` | RF-060 | API-008, ventas del día |
| 15–17 | `7a44878` | RNF-040, RF-010/011, RNF-041 | Hora SHOA, QR, BLE companion |
| 18 | `ca17541` | RNF-041 | BLE GATT POS |
| 19 | `7e70135` | RF-002 | Usuarios en UI |
| 20 | `1b367fe` | RF-070 | API-009 auditoría |
| 21 | `3cdf2ec` | RF-003 | API-010 certificado consulta |
| 22 | `43e0e13` | RF-060/070 | Drift reportes y auditoría |
| 23 | `c2f2470` | RF-041 | SC-041-UI-03 cierre sin turno |
| 24 | `a728144` | — | Runbook merge, reporte al día |
| 25 | `d6d39e8` | RF-003 | Índice piloto SII, guía UI SC-080-PREP |
| 26 | `86c5cbe` | — | `ci-local.ps1`, plantilla PR SC-026 |
| 27 | `70516a1` | RNF-041 | Índice piloto BLE, guía UI SC-011-PREP |
| 28 | `7e3db65` | — | Índice tienda piloto SC-028 |
| 29 | `62ec8f1` | — | Kit merge 0–28, `pr-merge-evidence.md` SC-029 |
| 30 | `38f9047` | — | `github-remote-setup`; intento PR SC-030 |
| 38–41 | `18a8314`…`22ddccc` | — | Reintentos PR, handoff operador, registro SC-030-01 |
| 42 | `20dad83` | — | Merge PR #1; acta revisión doc 19 |

Decisiones por slice: `docs/decisiones/DEC-*-slice*.md`.

Historial reciente:

```text
c2f2470 feat(slice-23): cierre sin turno SC-041-UI-03.
43e0e13 feat(slice-22): tests drift reportes y auditoría.
3cdf2ec feat(slice-21): estado certificado SII RF-003.
1b367fe feat(slice-20): auditoría mínima RF-070.
7e70135 feat(slice-19): alta de usuarios en UI.
ca17541 feat(slice-18): escáner BLE GATT companion-POS.
7a44878 feat(slice-15-17): hora SHOA, QR producto y escáner companion.
7149a7f feat(slice-14): RF-060 ventas del día.
```

---

## 3. Cobertura de requisitos funcionales (MVP)

Leyenda: **✅** implementado y con tests automatizados relevantes | **🔶** parcial / solo API o manual | **⬜** no implementado

| RF | Nombre | Estado | Evidencia principal |
|----|--------|--------|---------------------|
| RF-001 | Alta de tienda | ✅ | Core, drift, `store_setup_ui_e2e_test.dart` |
| RF-002 | Usuarios y roles | ✅ | Login, permisos, alta usuario UI (SLICE-19) |
| RF-003 | Certificado SII | ✅ | API-010 + piloto cert SC-080-03 **CERRADO** (SLICE-37) |
| RF-010 | Crear producto | ✅ | API + `product_create_ui_e2e_test.dart` |
| RF-011 | Buscar producto | ✅ | Core + flujo venta UI |
| RF-012 | Stock inicial | ✅ | Create product (opcional UI) |
| RF-020 | Consultar stock | ✅ | Core + adapters |
| RF-021 | Ajuste / merma | ✅ | `stock_adjust_ui_e2e_test.dart` |
| RF-030 | Carro venta | ✅ | `sale_flow_e2e_test.dart` |
| RF-031 | Confirmar venta | ✅ | Checkout, stock, DTE estado |
| RF-032 | Anular venta | ✅ | `void_sale_ui_e2e_test.dart` |
| RF-040 | Apertura turno | ✅ | App shell + venta |
| RF-041 | Cierre caja | ✅ | `close_shift_ui_e2e_test.dart` (SC-041-UI-01/02/03) |
| RF-050 | Emitir DTE | 🔶 | Fake/replay/live en tests; producción = piloto |
| RF-051 | Cola DTE | ✅ | `dte_queue_ui_e2e_test.dart` |
| RF-060 | Ventas del día | ✅ | SC-060-02 core/API, SC-060-UI-01 |
| RF-070 | Auditoría mínima | ✅ | SC-070-01 core/API, SC-070-UI-01/02 |
| RF-061…062, 022, 033…034, 042, 052, 013 | Should/Could | ⬜ | Fuera slices actuales |

Detalle escenario ↔ test: [`docs/12b-matriz-verificacion-automatizacion.md`](12b-matriz-verificacion-automatizacion.md).

---

## 4. Qué se puede probar (demostración)

### 4.1 App manual

```bash
cd apps/pos_app
flutter run
```

Flujos cubiertos por pruebas e2e (reproducibles manualmente):

| ID | Flujo | Archivo test |
|----|-------|--------------|
| SC-001-UI-01 | Onboarding tienda | `store_setup_ui_e2e_test.dart` |
| SC-060-01 | Venta completa | `sale_flow_e2e_test.dart` |
| SC-032-UI-01 | Anulación | `void_sale_ui_e2e_test.dart` |
| SC-041-UI-01/02/03 | Cierre / cajero / sin turno | `close_shift_ui_e2e_test.dart` |
| SC-002-UI-01 | Nuevo usuario (dueño) | `user_create_ui_e2e_test.dart` |
| SC-051-UI-01 | Cola DTE | `dte_queue_ui_e2e_test.dart` |
| SC-021-UI-01 | Merma stock | `stock_adjust_ui_e2e_test.dart` |
| SC-010-UI-* | Nuevo producto | `product_create_ui_e2e_test.dart` |
| SC-060-UI-01 | Ventas del día | `daily_sales_ui_e2e_test.dart` |
| SC-070-UI-01 | Auditoría del día | `audit_trail_ui_e2e_test.dart` |
| SC-003-UI-01 | Certificado SII | `certificate_status_ui_e2e_test.dart` |
| SC-080-ASSIST-UI-01/02 | Piloto SII: ver y copiar `sale_id` | `sii_checkout_evidence_ui_test.dart` |
| SC-011-BLE-UI (prep) | Guía / push BLE en Vender | `scanner_ble_ui_test.dart`, `scanner_ble_push_test.dart` |

**Credenciales demo [documentadas en código]:** usuario `usr_supervisor` / `usr_cajero` / `usr_dueno`, PIN `2468` (`PosComposition.demoPin`).

### 4.2 Suite automatizada (evidencia objetiva)

Desde la raíz del repositorio:

```bash
cd packages/core && dart pub get && dart test
cd packages/adapters && dart pub get && dart test
cd apps/pos_app && flutter pub get && flutter test
```

Última verificación al generar este reporte: **114 + 25 + 27** tests en verde en entorno local (`scripts/ci-local.ps1`, 2026-11-19).

### 4.3 Contratos y aceptación

- Contratos: [`docs/07-contratos-api-publica.md`](07-contratos-api-publica.md)
- Gherkin por slice: `test/acceptance/slice_*.md`
- Changelog: [`docs/CHANGELOG.md`](CHANGELOG.md)

---

## 5. Pendientes que afectan el relato “listo para producción”

| Prioridad | Ítem | Acción para evidenciar |
|-----------|------|-------------------------|
| Baja | Backlog §8 acta | Tag **`mvp-2026-11`** (`ddd071e`); BLE PREPARADO; Gate 2 parcial; SLICE-9 y SII prod **N/A** |

---

## 6. Riesgos y supuestos declarados

- **Rama larga:** histórico en `feat/slice-0-scaffold`; merge MVP en `main` (`20dad83`, 2026-11-19).
- **Gate 2:** documento [`17-cierre-gate-2.md`](17-cierre-gate-2.md) sigue en estado abierto [OBSERVADO]; implementación avanzó con TDD igualmente.
- **DTE producción:** depende de certificado vigente y piloto; modo `FakeDteGateway` válido para demos.

---

## 7. Anexo — Inventario rápido de APIs

| API | Ámbito |
|-----|--------|
| API-001 | Productos |
| API-002 | Carro y venta |
| API-003 | Turno y cierre |
| API-004 | Inventario |
| API-005 | Cola DTE |
| API-006 | Autenticación |
| API-007 | Tienda |
| API-008 | Reporte ventas del día |
| API-009 | Auditoría del día |
| API-010 | Certificado fiscal (consulta) |

---

## 8. Control de versiones de este documento

| Versión | Fecha | Cambio |
|---------|-------|--------|
| 1.0 | 2026-03-18 | Primera edición post SLICE-14 |
| 1.1 | 2026-11-19 | Slices 15–24, APIs 009/010, conteos test, runbook merge |

**Responsable de actualización:** equipo POS / quien cierre cada slice (actualizar §2, §3 y conteos de §1).