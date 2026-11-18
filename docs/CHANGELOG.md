# Changelog

Formato basado en [Keep a Changelog](https://keepachangelog.com/es-ES/).

## [Unreleased]

### Added

- SLICE-11: operación diaria en UI — cierre caja, cola DTE, ajuste stock; menú operación; CI GitHub Actions (DEC-033); matriz `12b`.
- SLICE-10 UI: pantalla ventas del turno, anulación supervisor, `ListShiftSales`, SC-032-UI-01.
- SLICE-10: `VoidSale`, `Permission.anularVenta`, API `POST .../void`, drift `sales.status` v8, SC-032.
- SLICE-8 Fase B: `SiiLiveDteGateway`, `HttpSiiTransport`, folios CAF (`dte_folio_counters` v7), SC-080-04/05.
- SLICE-8 Fase A: `SiiCertReplayDteGateway`, `CertificateStore`, runbook cert SII; cert live pendiente (Fase B).
- SLICE-7: roles y PIN — `AuthService` (API-006), matriz RF-002 en casos de uso, tabla `users` drift v6, login en app.
- SLICE-6: app Flutter — Drift local-first, turno → venta → cobro con `dteStatus`, integration_test SC-060-01.
- SLICE-5: DTE fake — `DteGateway`, `FakeDteGateway`, cola `DteQueueRepository`, checkout con `dteStatus`/`folio`, API-005 `DteService`, drift schema v5 (`dte_queue`, columnas DTE en `sales`).
- Contrato API: tests de errores HTTP en `packages/core/test/api/*` (SC-010/021/031/040/041).
- SLICE-4: turno — `OpenShift`, `CloseShift`, `ShiftService` (API-003); checkout exige turno; drift schema v4.
- SLICE-3: ventas — carro, checkout, `SaleService` (API-004 sin DTE), `DriftSaleRepository` schema v3.
- SLICE-2: inventario — `GetProductStock`, `AdjustStock`, `InventoryService` (API-004), `stock_movements` drift.
- SLICE-1: catálogo — dominio `Product`, `CreateProduct`, `SearchProducts`, `ProductService` (API-001).
- Tests SC-010/011 en `packages/core`; acceptance `test/acceptance/slice_01_catalogo.md`.
- `DriftProductRepository` + tabla `products` en `packages/adapters`.
- Gate 2 mínimo catálogo: DEC-002/003/006–010/016–017, DDL `08b`.
- SLICE-0: monorepo `apps/pos_app`, `packages/core`, `packages/adapters`.
- Smoke tests en `core` y `adapters`.
- App Flutter pantalla «POS barrio — SLICE-0» enlazada a `package:core`.
- README operativo y DEC-001 (monorepo manual).