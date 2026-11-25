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
| SC-085-UI-01 | RF-085 | — | — | ✅ | `stock_receipt_ui_e2e_test.dart` |
| SC-085-UI-02 | RF-085 | — | — | ✅ | Mismo archivo |
| SC-085-UI-03 | RF-085 | — | — | ✅ | `stock_menu_cajero_ui_test.dart` |
| SC-087-UI-01 | RF-087 | — | — | ✅ | `stock_insights_ui_e2e_test.dart` |
| SC-087-UI-02 | RF-087 | — | — | ✅ | Mismo archivo |
| SC-087-UI-03 | RF-087 | — | — | ✅ | `stock_menu_cajero_ui_test.dart` |
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
| SC-078-01 | RF-080 | — | — | ✅ | `credential_policy_test`, formatters UI |
| SC-079-UI-01 | RF-091 | — | — | ✅ | `product_stock_list_ui_e2e_test.dart` |
| SC-084-UI-01 | RF-091 | — | — | ✅ | `product_stock_list_ui_e2e_test.dart` — `product_stock_new_button` |
| SC-084-UI-02 | RF-091 | — | — | ✅ | cajero sin botón |
| SC-084-UI-03 | RF-091 | — | — | ✅ | navegación a `product_create_name_field` |
| SC-085-01 | RF-094 | — | — | ✅ | `scan_session_service_test.dart` |
| SC-085-02 | RF-094 | — | — | ✅ | countScan |
| SC-085-03 | RF-094 | — | — | ✅ | bip + quantity |
| SC-085-04 | RF-094 | — | — | ✅ | antirrebote 400 ms |
| SC-085-05 | RF-094 | — | — | ✅ | código desconocido 404 |
| SC-085-06 | RF-094 | — | — | ✅ | cajero 403 |
| SC-085-07 | RF-094 | — | — | ✅ | cancel + bip bloqueado |
| SC-086-01 | RF-085 | — | — | ✅ | `scan_session_confirm_test.dart` |
| SC-086-02 | RF-085 | — | — | ✅ | líneas vacías |
| SC-086-03 | RF-085 | — | — | ✅ | countScan |
| SC-086-04 | RF-085 | — | — | ✅ | doble confirm 409 |
| SC-086-05 | RF-085 | — | — | ✅ | idempotency |
| SC-086-06 | RF-085 | — | — | ✅ | cajero 403 |
| SC-086-07 | RF-085 | — | — | ✅ | refs RECEPCION |
| SC-087-UI-01 | RF-085 | — | — | ✅ | `stock_receipt_scan_ui_e2e_test.dart` |
| SC-087-UI-02 | RF-085 | — | — | ✅ | regresión manual |
| SC-087-UI-03 | RF-085 | — | — | ✅ | crear producto barcode |
| SC-087-UI-04 | RF-085 | — | — | ✅ | confirm sin líneas |
| SC-081-01 | RF-092 | — | — | ✅ | `qr_labels_pdf_test.dart` |
| SC-082-01 | RF-093 | ✅ | — | ✅ | `end_session_test.dart`, `sale_change_session` |
| SC-010-QR-01 | RF-010 | ✅ | ✅ | ✅ | `product_qr_test`, QR en create UI |
| SC-011-QR-01 | RF-011 | ✅ | ✅ | — | `search_products_test` |
| SC-011-PREP-01 | RNF-041 | — | — | — | Docs — `runbooks/ble-piloto-indice.md`, pre-vuelo evidencia |
| SC-080-01 | RNF-041 | — | — | ✅ | `scanner_ble_ui_test.dart` — sin `scanner_pilot_guide` |
| SC-011-BLE-01 | RNF-041 | — | — | ⬜ | Piloto BLE real — `ble-scanner-pilot-evidence.md` (PREPARADO); SLICE-48 prep — `slice_48_ble_pre_pilot.md`, `ble-piloto-dia-cero.md`; manual hasta CERRADO |
| SC-011-BLE-02 | RNF-041 | ✅ | — | — | `scan_payload_codec_test` |
| SC-011-BLE-03 | RNF-041 | ✅ | — | ✅ | `companion_pairing_match_test`; `pos_app` + `flutter_blue_plus_windows` |
| SC-011-BLE-UI-01 | RNF-041 | — | ✅ | ✅ | `scanner_ble_ui_test`, `scanner_ble_push_test` |
| SC-070-01 | RF-070 | ✅ | ✅ | — | `get_audit_trail_test`, `report_service_test`, `drift_audit_trail_test`, `drift_stock_movement_range_test` |
| SC-070-UI-01 | RF-070 | — | — | ✅ | `audit_trail_ui_e2e_test.dart` |
| SC-070-UI-02 | RF-070 | — | — | ✅ | Mismo archivo |
| SC-086-UI-01 | RF-086 | — | — | ✅ | `audit_trail_range_ui_e2e_test.dart` |
| SC-086-UI-02 | RF-086 | — | — | ✅ | Mismo archivo |
| SC-086-UI-03 | RF-086 | — | — | ✅ | Mismo archivo |
| SC-088-UI-01 | RF-088 | — | — | ✅ | `inventory_close_ui_e2e_test.dart` |
| SC-088-UI-02 | RF-088 | — | — | ✅ | Mismo archivo |
| SC-088-UI-03 | RF-088 | — | — | ✅ | Mismo archivo |
| SC-088-UI-04 | RF-088 | — | — | ✅ | `inventory_close_menu_cajero_ui_test.dart` |
| SC-075-UI-01 | — | — | — | ✅ | `ui_shell_sale_e2e_test.dart` |
| SC-075-UI-02 | — | — | — | ✅ | Mismo archivo |
| SC-075-UI-03 | — | — | — | ✅ | Mismo archivo |
| SC-076-UI-01 | RF-089 | — | — | ✅ | `pos_menu_template_ui_e2e_test.dart` |
| SC-076-UI-02 | RF-089 | — | — | ✅ | Mismo archivo |
| SC-076-UI-03 | RF-089 | — | — | ✅ | Mismo archivo |
| SC-076-UI-04 | RF-089 | — | — | ✅ | Mismo archivo |
| SC-080-UI-01 | RF-080 | — | — | ✅ | `user_management_ui_e2e_test.dart` |
| SC-080-UI-02 | RF-080 | — | — | ✅ | Mismo archivo |
| SC-080-UI-03 | RF-080 | — | — | ✅ | Mismo archivo |
| SC-080-UI-04 | RF-080 | — | — | ✅ | Mismo archivo |
| SC-082-UI-01 | RF-082 | — | — | ✅ | `cart_editable_ui_e2e_test.dart` |
| SC-082-UI-02 | RF-082 | — | — | ✅ | Mismo archivo |
| SC-082-UI-03 | RF-082 | — | — | ✅ | Mismo archivo |
| SC-084-UI-01 | RF-084 | — | — | ✅ | `seller_code_checkout_ui_e2e_test.dart` |
| SC-084-UI-02 | RF-084 | — | — | ✅ | Mismo archivo |
| SC-084-UI-03 | RF-084 | — | — | ✅ | Mismo archivo |
| SC-077-01 | — | — | — | — | `ci-local.ps1` en SLICE-77 |
| SC-077-02 | — | — | — | — | Push `origin/main` `f5eba61` — `pr-merge-evidence.md` § SLICE-77 |
| SC-077-03 | — | — | — | — | Acta 19 §12 |
| SC-077-04 | — | — | — | — | Doc 20 estado R2 cerrada |
| SC-002-UI-01 | RF-002 | — | — | ✅ | `user_create_ui_e2e_test.dart` |
| SC-002-UI-02 | RF-002 | — | — | ✅ | Mismo archivo |
| SC-003-01 | RF-003 | ✅ | — | — | `get_certificate_status_*`, `fiscal_service_test` |
| SC-003-UI-01 | RF-003 | — | — | ✅ | `certificate_status_ui_e2e_test.dart` |
| SC-003-UI-02 | RF-003 | — | — | ✅ | Mismo archivo |
| SC-080-PREP-01 | RF-003 | — | — | — | Docs — `runbooks/sii-piloto-indice.md`, pre-vuelo evidencia |
| SC-080-PREP-UI-01 | RF-003 | — | — | ✅ | `certificate_status_ui_e2e_test.dart` — `certificate_pilot_guide` |
| SC-080-ASSIST-UI-01 | RF-003 | — | — | ✅ | `sii_checkout_evidence_ui_test.dart` — `checkout_sale_id_label` |
| SC-080-ASSIST-UI-02 | RF-003 | — | — | ✅ | `sii_checkout_evidence_ui_test.dart` — `checkout_copy_sale_id_button` |
| SC-080-03 | RF-003 | — | — | ✅ | Manual cerrado SLICE-37 — `runbooks/sii-cert-pilot-evidence.md` **CERRADO** |
| SC-026-01 | — | — | — | — | Paridad local/CI — `scripts/ci-local.ps1`, `merge-mvp-hito.md` |
| SC-026-02 | — | — | — | — | Kit PR — `pr-body-mvp.md`, README/reporte |
| SC-028-01 | — | — | — | — | Docs — `runbooks/tienda-piloto-indice.md` |
| SC-028-02 | — | — | — | — | Docs — `runbooks/tienda-piloto-evidencia.md` |
| SC-028-03 | RF-030/031 | — | — | — | Manual — demo fake tienda CERRADO (SLICE-53); evidencia **PARCIAL** global |
| SC-029-01 | — | — | — | — | Docs — título PR 0–28 en `merge-mvp-hito.md` |
| SC-029-02 | — | — | — | — | Docs — `runbooks/pr-merge-evidence.md` |
| SC-030-00 | — | — | — | — | Docs — `github-remote-setup.md` |
| SC-030-01 | — | — | — | ✅ | PR abierto — https://github.com/mmb21894-ux/pos-barrio-segmento-d/pull/1 |
| SC-030-02 | — | — | — | ✅ | Evidencia MERGED; `main` `20dad83`; feature `22ddccc` |
| SC-031-00 | — | — | — | — | Docs — reintento SLICE-31 en `pr-merge-evidence.md` |
| SC-032-00 | — | — | — | — | Docs — reintento SLICE-32 en `pr-merge-evidence.md` |
| SC-034-00 | — | — | — | — | Docs — reintento SLICE-34 en `pr-merge-evidence.md` |
| SC-038-00 | — | — | — | — | Docs — reintento SLICE-38 en `pr-merge-evidence.md` |
| SC-039-00 | — | — | — | — | Docs — reintento SLICE-39 en `pr-merge-evidence.md` |
| SC-040-00 | — | — | — | — | Docs — handoff SLICE-40; `slice-40-operador-pr-checklist.md` |
| SC-041-00 | — | — | — | — | Docs — registro SLICE-41; gate URL; `slice_41_pr_registrado.md` |
| SC-042-00 | — | — | — | — | Docs — merge PR #1 + acta `19-revision-progreso-20251119.md` |
| SC-043-00 | — | — | — | ✅ | Docs — main `6032997`; `slice_43_main_alineado.md` |

Actualizar esta tabla al cerrar cada slice con escenarios UI nuevos.