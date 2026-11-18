# 12b — Matriz verificación (escenario ↔ automatización)

Leyenda: ✅ = cubierto por tests | 🔶 = parcial | ⬜ = manual / pendiente

| ID | RF | Core | Adapters | App | Manual / nota |
|----|-----|------|----------|-----|----------------|
| SC-041-01 | RF-041 | ✅ | ✅ | ✅ SLICE-11 | — |
| SC-041-02 | RF-041 | ✅ | — | 🔶 | Sin UI dedicada |
| SC-041-UI-01 | RF-041 | — | — | ✅ | `close_shift_ui_e2e_test.dart` |
| SC-041-UI-02 | RF-041 | — | — | ✅ | Mismo archivo |
| SC-051-01 | RF-051 | ✅ | ✅ | — | — |
| SC-051-02 | RF-051 | ✅ | — | ✅ SLICE-11 | `dte_queue_ui_e2e_test.dart` |
| SC-051-UI-01 | RF-051 | — | — | ✅ | Cola + reintento UI |
| SC-021-01 | RF-021 | ✅ | ✅ | ✅ SLICE-11 | `stock_adjust_ui_e2e_test.dart` |
| SC-021-UI-01 | RF-021 | — | — | ✅ | Merma UI |
| SC-032-UI-01 | RF-032 | — | — | ✅ | `void_sale_ui_e2e_test.dart` |
| SC-060-01 | RF-030 | — | — | ✅ | `sale_flow_e2e_test.dart` |
| SC-080-03 | RF-003 | — | — | ⬜ | Piloto cert SII — ver `runbooks/sii-cert-pilot-evidence.md` |

Actualizar esta tabla al cerrar cada slice con escenarios UI nuevos.