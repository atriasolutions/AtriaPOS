# 10 — Plan de entregas (vertical slices)

Cada slice entrega valor demostrable y tests verdes.

| Slice | ID | Objetivo | RF principal | DoD |
|-------|-----|----------|--------------|-----|
| 0 | SLICE-0 | Repo Git, `packages/core` vacío, CI local | — | `dart test` corre; docs en `docs/` |
| 1 | SLICE-1 | Producto + búsqueda | RF-010, RF-011 | API-001 tests verdes |
| 2 | SLICE-2 | Inventario consulta y ajuste | RF-020, RF-021 | API-004 tests verdes |
| 3 | SLICE-3 | Carro + confirmar venta (sin DTE) | RF-030, RF-031 parcial | Stock y totales |
| 4 | SLICE-4 | Turno y cierre caja | RF-040, RF-041 | No checkout sin turno |
| 5 | SLICE-5 | DTE fake + estados | RF-050, RF-051 | PENDIENTE vs EMITIDA |
| 6 | SLICE-6 | App Flutter POS mínima | RF-030 UI | 1 flujo e2e smoke |
| 7 | SLICE-7 | Roles + PIN | RF-002 | Matriz permisos |
| 8 | SLICE-8 | Certificación SII | RF-003, RF-050 real | Ambiente cert OK |
| 10 | SLICE-10 | Anulación venta del día | RF-032 | Stock revertido; caja excluye anuladas |
| 11 | SLICE-11 | Operación supervisor + CI | RF-041, RF-051, RF-021 UI | Cierre/cola/ajuste en app; workflow verde |
| 12 | SLICE-12 | Alta de tienda | RF-001 | Bootstrap dueño; emisor desde DB |
| 13 | SLICE-13 | Catálogo en UI | RF-010, RF-012 | Crear producto en app |
| 14 | SLICE-14 | Reporte ventas del día | RF-060 | API-008; pantalla supervisor |
| 15 | SLICE-15 | Hora SHOA en UI y eventos | RNF-040 | TrustedClock, reloj esquina |
| 16 | SLICE-16 | QR por producto | RF-010/011 | qr_payload + imagen |
| 17 | SLICE-17 | Escáner companion BLE | RNF-041 | `scanner_companion` + ingress |
| 18 | SLICE-18 | BLE GATT companion→POS | RNF-041 | Codec, `BleCentralScannerIngress`, NOTIFY |
| 19 | SLICE-19 | Usuarios en UI | RF-002 | Dueño crea cajero/supervisor |
| 20 | SLICE-20 | Auditoría del día | RF-070 | API-009; `confirmedByUserId`; pantalla supervisor |
| 21 | SLICE-21 | Estado certificado SII | RF-003 | API-010; menú supervisor/dueño; sin carga .pfx en app |
| 22 | SLICE-22 | Drift reportes y auditoría | RF-060, RF-070 | Tests adapters SC-060-02 / SC-070-01 |
| 23 | SLICE-23 | Cierre sin turno en UI | RF-041 | SC-041-UI-03; Key `close_shift_no_open_message` |
| 24 | SLICE-24 | Hito merge MVP | — | Runbook PR; reporte/README; suites verdes locales |
| 25 | SLICE-25 | Prep piloto SII | RF-003 | Índice runbooks; guía UI; SC-080-PREP; SC-080-03 sigue manual |
| 26 | SLICE-26 | Hito merge MVP | — | `ci-local.ps1`, `pr-body-mvp.md`; SC-026; listo para PR (merge manual) |
| 27 | SLICE-27 | Prep piloto BLE | RNF-041 | Índice runbooks; guía UI Vender; SC-011-PREP; SC-011-BLE-01 manual |
| 28 | SLICE-28 | Índice tienda piloto | — | `tienda-piloto-indice.md` + evidencia; SC-028; pilotos hijos manual |
| 29 | SLICE-29 | Alineación kit merge | — | PR título 0–28; `pr-merge-evidence.md`; SC-029; merge manual |
| 30 | SLICE-30 | Ejecutar PR MVP | — | push + `gh pr create`; SC-030; merge manual |
| 31 | SLICE-31 | Cierre PR MVP | — | Reintento SC-030; evidencia ABIERTO; título 0-30; sin merge |
| 32 | SLICE-32 | Ejecutar PR SC-030 | — | Push; `gh pr create` 0-31; SC-030; sin merge |
| 33 | SLICE-33 | Asistencia piloto SII | RF-003 | UI `sale_id` post-checkout; SC-080-ASSIST-UI-01; SC-080-03 manual |
| 34 | SLICE-34 | Ejecutar PR SC-030 | — | Push; `gh pr create` 0-33; SC-030; sin merge |
| 35 | SLICE-35 | Copiar sale_id piloto | RF-003 | SC-080-ASSIST-UI-02; SC-080-03 manual |
| 36 | SLICE-36 | Diagnóstico pruebas | — | Informe doc 18; cobertura core; recomendación próximo slice |
| 37 | SLICE-37 | Piloto cert SII | RF-003 | SC-080-03 evidencia **CERRADO**; rollback fake |
| 38 | SLICE-38 | Ejecutar PR MVP | — | Push + `gh pr create` 0-37; SC-030-01 ABIERTO si remoto+gh OK |
| 39 | SLICE-39 | Ejecutar PR MVP | — | Reintento título **0-38**; SC-030-01 ABIERTO si remoto+gh en sesión activa |
| 40 | SLICE-40 | Cierre PR operador | — | Checklist handoff; SC-030-01 ABIERTO al registrar URL |
| 41 | SLICE-41 | Registrar PR | — | SC-030-01 ABIERTO; PR #1 en `pos-barrio-segmento-d` |
| 42 | SLICE-42 | Merge MVP `main` | — | PR #1 MERGED; evidencia + acta [`19-revision-progreso-20251119.md`](19-revision-progreso-20251119.md) |
| 43 | SLICE-43 | Alinear `main` post-merge | — | PR #2 MERGED; `main` `6032997`; backlog §8 acta |
| 44 | SLICE-44 | Piloto BLE documental | RNF-041 | Acceptance SC-011-BLE-01; handoff evidencia **PREPARADO**; SC-011-BLE-01 manual hasta CERRADO |
| 45 | SLICE-45 | Gate 2 DEC retroactivos | — | ADR DEC-004/005/011/012; doc 16/17 parcial; sin cambio checkout |
| 46 | SLICE-46 | Tag MVP `mvp-2026-11` | — | PR #5 merge 44–45; tag en `main` `ddd071e`; acceptance SC-046 |
| 47 | SLICE-47 | Acta post-tag | — | `19-revision-progreso-20251120.md`; reporte/evidencia; higiene ramas doc |
| 48 | SLICE-48 | Pre-piloto BLE | RNF-041 | Companion en CI; `ble-piloto-dia-cero.md`; SC-011-BLE-01 manual hasta CERRADO |
| 49 | SLICE-49 | Integración main 47–48 | — | PR #6/#7/#8 MERGED; acta/evidencia; tag sin mover |
| 50 | SLICE-50 | Piloto BLE evidencia | RNF-041 | **ABIERTO** — SC-011-BLE-01; evidencia CERRADO en hardware |
| 51 | SLICE-51 | Acta backlog | — | `main` `2f10165`; SLICE-50 ABIERTO explícito; §8 acta |
| 52 | SLICE-52 | Central BLE Windows | RNF-041 | `flutter_blue_plus_windows`; SC-011-BLE-03; companion service data; smoke manual; SC-011-BLE-01 sigue abierto |
| 53 | SLICE-53 | Piloto tienda demo | RF-030/031 | Evidencia **PARCIAL**; SC-028-03; BLE (SLICE-50) pendiente |
| 9 | SLICE-9 | Integración terminal pago | — | **N/A** — diferido explícito; no bloquea slices 43+ |

## Orden TDD sugerido (semana orientativa)

| Semana | Slice | Entregable demo |
|--------|-------|-----------------|
| 1 | 0–1 | Crear/buscar producto por API/tests |
| 2 | 2–3 | Venta descuenta stock |
| 3 | 4–5 | Cierre caja + boleta fake |
| 4 | 6 | Tablet: venta real en UI |
| 5+ | 7–8 | Piloto certificación |

## Branching

- `main` estable.
- `feat/slice-N-descripcion` por vertical.
- No merge sin tests del slice en verde.

## Artefactos por slice

1. Actualizar `test/acceptance/*.md` si cambia comportamiento.
2. Changelog breve en `docs/CHANGELOG.md` (crear al SLICE-0).