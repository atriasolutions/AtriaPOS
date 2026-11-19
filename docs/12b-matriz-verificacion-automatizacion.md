# 12b — Matriz verificación (escenario ↔ automatización)

Leyenda: ✅ = cubierto por tests | 🔶 = parcial | ⬜ = manual / pendiente

| ID | RF | Core | Adapters | App | Manual / nota |
|----|-----|------|----------|-----|----------------|
| SC-041-01 | RF-041 | ✅ | ✅ | ✅ SLICE-11 | — |
| SC-041-02 | RF-041 | ✅ | — | ✅ | SC-041-UI-03 en `close_shift_ui_e2e_test.dart` |
| SC-041-UI-01 | RF-041 | — | — | ✅ | `close_shift_ui_e2e_test.dart` |
| SC-041-UI-02 | RF-041 | — | — | ✅ | Mismo archivo |
| SC-041-UI-03 | RF-041 | — | — | ✅ | Cierre sin turno abierto |
| SC-051-01 | RF-051 | ✅ | ✅ | — | — |
| SC-051-02 | RF-051 | ✅ | — | ✅ SLICE-11 | `dte_queue_ui_e2e_test.dart` |
| SC-051-UI-01 | RF-051 | — | — | ✅ | Cola + reintento UI |
| SC-021-01 | RF-021 | ✅ | ✅ | ✅ SLICE-11 | `stock_adjust_ui_e2e_test.dart` |
| SC-021-UI-01 | RF-021 | — | — | ✅ | Merma UI |
| SC-032-UI-01 | RF-032 | — | — | ✅ | `void_sale_ui_e2e_test.dart` |
| SC-060-01 | RF-030 | — | — | ✅ | `sale_flow_e2e_test.dart` |
| SC-060-02 | RF-060 | ✅ | ✅ | — | `get_daily_sales_report_test`, `report_service_test`, `drift_daily_report_test` |
| SC-060-UI-01 | RF-060 | — | — | ✅ | `daily_sales_ui_e2e_test.dart` |
| SC-010-UI-01 | RF-010 | — | — | ✅ | `product_create_ui_e2e_test.dart` |
| SC-010-UI-02 | RF-010 | — | — | ✅ | Mismo archivo |
| SC-010-UI-03 | RF-010 | — | — | ✅ | Validación precio en UI |
| SC-001-01 | RF-001 | ✅ | ✅ | — | `bootstrap_store_test`, `drift_store_test` |
| SC-001-02 | RF-001 | ✅ | — | — | Core |
| SC-001-03 | RF-001 | ✅ | — | — | Core |
| SC-001-UI-01 | RF-001 | — | — | ✅ | `store_setup_ui_e2e_test.dart` |
| SC-015-UI-01 | RNF-040 | — | — | ✅ | `pos_clock_overlay_test.dart` |
| SC-040-03 | RF-040 | ✅ | — | ✅ | `shift_open_time_label` en venta |
| SC-041-03 | RF-041 | ✅ | — | ✅ | `close_shift_screen` timestamps |
| SC-031-03 | RF-031 | ✅ | — | ✅ | diálogo checkout `createdAt` |
| SC-010-QR-01 | RF-010 | ✅ | ✅ | ✅ | `product_qr_test`, QR en create UI |
| SC-011-QR-01 | RF-011 | ✅ | ✅ | — | `search_products_test` |
| SC-011-BLE-01 | RNF-041 | — | — | 🔶 | Manual — `runbooks/ble-scanner-pairing.md` |
| SC-011-BLE-02 | RNF-041 | ✅ | — | — | `scan_payload_codec_test` |
| SC-011-BLE-UI-01 | RNF-041 | — | ✅ | ✅ | `scanner_ble_ui_test`, `scanner_ble_push_test` |
| SC-070-01 | RF-070 | ✅ | ✅ | — | `get_audit_trail_test`, `report_service_test`, `drift_audit_trail_test`, `drift_stock_movement_range_test` |
| SC-070-UI-01 | RF-070 | — | — | ✅ | `audit_trail_ui_e2e_test.dart` |
| SC-070-UI-02 | RF-070 | — | — | ✅ | Mismo archivo |
| SC-002-UI-01 | RF-002 | — | — | ✅ | `user_create_ui_e2e_test.dart` |
| SC-002-UI-02 | RF-002 | — | — | ✅ | Mismo archivo |
| SC-003-01 | RF-003 | ✅ | — | — | `get_certificate_status_*`, `fiscal_service_test` |
| SC-003-UI-01 | RF-003 | — | — | ✅ | `certificate_status_ui_e2e_test.dart` |
| SC-003-UI-02 | RF-003 | — | — | ✅ | Mismo archivo |
| SC-080-PREP-01 | RF-003 | — | — | — | Docs — `runbooks/sii-piloto-indice.md`, pre-vuelo evidencia |
| SC-080-PREP-UI-01 | RF-003 | — | — | ✅ | `certificate_status_ui_e2e_test.dart` — `certificate_pilot_guide` |
| SC-080-03 | RF-003 | — | — | ⬜ | Piloto cert SII real — `runbooks/sii-cert-pilot-evidence.md` (hasta estado CERRADO) |
| SC-026-01 | — | — | — | — | Paridad local/CI — `scripts/ci-local.ps1`, `merge-mvp-hito.md` |
| SC-026-02 | — | — | — | — | Kit PR — `pr-body-mvp.md`, README/reporte |

Actualizar esta tabla al cerrar cada slice con escenarios UI nuevos.