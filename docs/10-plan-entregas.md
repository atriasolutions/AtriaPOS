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
| 9 | SLICE-9 | Integración terminal pago | — | Opcional post-MVP |

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