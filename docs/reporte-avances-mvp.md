# Reporte de avances — Sistema POS segmento D

**Proyecto:** POS barrio (Chile), núcleo local-first  
**Fecha de reporte:** 2026-03-18  
**Rama de trabajo:** `feat/slice-0-scaffold` (HEAD `7149a7f`)  
**Organización:** Atria Solutions SpA  

---

## 1. Resumen ejecutivo

El producto cuenta con un **MVP vertical implementado en código** desde SLICE-0 hasta **SLICE-14**, con arquitectura Flutter + dominio Dart (`packages/core`) y persistencia Drift (`packages/adapters`). La operación diaria de una tienda piloto es **demostrable en app**: alta de tienda, login por PIN, turno, venta con stock, DTE en modo desarrollo, cierre de caja, anulaciones, ajuste de stock, catálogo en UI y **reporte de ventas del día**.

| Indicador | Valor [OBSERVADO] |
|-----------|-------------------|
| Slices cerrados (plan 10) | 0–8 (fases A/B), 10–14; **9 opcional** sin iniciar |
| Contratos API publicados | API-001 … API-008 (`docs/07-contratos-api-publica.md`) |
| Escenarios acceptance | 14 archivos `test/acceptance/slice_*.md` |
| Tests automatizados | Core **98**, adapters **22**, app **14** (widget/e2e) |
| CI | GitHub Actions: core + adapters + `flutter test` (`.github/workflows/ci.yml`) |
| Piloto SII real | **Pendiente** — `SC-080-03` manual (`runbooks/sii-cert-pilot-evidence.md`) |

**Lectura de madurez:** listo para **piloto operativo en tienda** con DTE fake/replay y certificación como hito explícito; no listo para declarar “producción fiscal” sin completar evidencia SC-080-03.

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

Decisiones por slice: `docs/decisiones/DEC-*-slice*.md` (14 DEC/ADR de cierre).

Historial reciente:

```text
7149a7f feat(slice-14): RF-060 ventas del día.
4387509 feat(slice-13): RF-010 crear producto en UI.
ba60e09 feat(slice-12): RF-001 alta de tienda y onboarding dueño.
baaf7b3 feat(slice-11): operación supervisor en UI, CI y matriz.
```

---

## 3. Cobertura de requisitos funcionales (MVP)

Leyenda: **✅** implementado y con tests automatizados relevantes | **🔶** parcial / solo API o manual | **⬜** no implementado

| RF | Nombre | Estado | Evidencia principal |
|----|--------|--------|---------------------|
| RF-001 | Alta de tienda | ✅ | Core, drift, `store_setup_ui_e2e_test.dart` |
| RF-002 | Usuarios y roles | ✅ | Login, permisos, alta usuario UI (SLICE-19) |
| RF-003 | Certificado SII | 🔶 | Consulta UI API-010; piloto SC-080-03 ⬜ manual |
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
| SC-041-UI-01/02 | Cierre / cajero sin menú | `close_shift_ui_e2e_test.dart` |
| SC-051-UI-01 | Cola DTE | `dte_queue_ui_e2e_test.dart` |
| SC-021-UI-01 | Merma stock | `stock_adjust_ui_e2e_test.dart` |
| SC-010-UI-* | Nuevo producto | `product_create_ui_e2e_test.dart` |
| SC-060-UI-01 | Ventas del día | `daily_sales_ui_e2e_test.dart` |
| SC-070-UI-01 | Auditoría del día | `audit_trail_ui_e2e_test.dart` |
| SC-003-UI-01 | Certificado SII | `certificate_status_ui_e2e_test.dart` |

**Credenciales demo [documentadas en código]:** usuario `usr_supervisor` / `usr_cajero` / `usr_dueno`, PIN `2468` (`PosComposition.demoPin`).

### 4.2 Suite automatizada (evidencia objetiva)

Desde la raíz del repositorio:

```bash
cd packages/core && dart pub get && dart test
cd packages/adapters && dart pub get && dart test
cd apps/pos_app && flutter pub get && flutter test
```

Última verificación al generar este reporte: **114 + 25 + 24** tests en verde en entorno local.

### 4.3 Contratos y aceptación

- Contratos: [`docs/07-contratos-api-publica.md`](07-contratos-api-publica.md)
- Gherkin por slice: `test/acceptance/slice_*.md`
- Changelog: [`docs/CHANGELOG.md`](CHANGELOG.md)

---

## 5. Pendientes que afectan el relato “listo para producción”

| Prioridad | Ítem | Acción para evidenciar |
|-----------|------|-------------------------|
| Alta | Piloto certificación SII (RF-003 / SLICE-8 DoD) | Completar [`runbooks/sii-cert-pilot-evidence.md`](../runbooks/sii-cert-pilot-evidence.md) |
| Baja | RF-061/062, terminal pago (SLICE-9), merge `main` | Roadmap post-piloto |

---

## 6. Riesgos y supuestos declarados

- **Rama larga:** trabajo acumulado en `feat/slice-0-scaffold`; conviene PR/merge a `main` con CI verde como hito de reporte.
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

---

## 8. Control de versiones de este documento

| Versión | Fecha | Cambio |
|---------|-------|--------|
| 1.0 | 2026-03-18 | Primera edición post SLICE-14 |

**Responsable de actualización:** equipo POS / quien cierre cada slice (actualizar §2, §3 y conteos de §1).