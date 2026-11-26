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
| 54 | SLICE-54 | Cierre revisión 1 | — | Evidencia operador; PR 52–53 → `main`; acta §10; plan R2 en doc 20 |
| 55 | SLICE-55 | Marca Atria POS + repo | — | DEC-044; README/AGENTS; runbook migración; push `atria-pos` |
| 56 | SLICE-56 | Identidad técnica Atria POS | — | kAppName, BLE, BD, barrel `atria_pos_core.dart` |
| 57 | SLICE-57 | Higiene sin nombres propios | — | DEC-045; `check-no-person-names`; CI |
| 58 | SLICE-58 | Migración org AtriaPOS | — | DEC-046; mirror; archivar atria-pos personal |
| 9 | SLICE-9 | Integración terminal pago | — | **N/A** — diferido explícito; no bloquea slices 43+ |

## Revisión 2 (Atria POS)

Detalle: [`20-plan-revision-2-atria-pos.md`](20-plan-revision-2-atria-pos.md). **Gate R2** (SLICE-59) antes de código R2. SLICE-50 BLE **paralelo**, no bloquea.

| # | Slice | Fase | Resumen | RF prop. | DoD resumido |
|---|-------|------|---------|----------|--------------|
| 59 | SLICE-59 | Gate | Gate R2 + plan R2 | — | Checklist §3 doc 20; `slice_59_gate_revision_2.md` ✅ |
| 60 | SLICE-60 | R2-A | Perfil usuario; credenciales sin ñ | RF-080 | Tests dominio/auth ✅ |
| 61 | SLICE-61 | R2-A | Permisos heredados | RF-081 | `auth_policy_test` ✅ |
| 62 | SLICE-62 | R2-A | Carrito editable (roles venta) | RF-082 | API carrito verde ✅ |
| 63 | SLICE-63 | R2-A | Planilla colaboradores | RF-083 | CRUD + persistencia ✅ |
| 64 | SLICE-64 | R2-A | Código vendedor en venta | RF-084 | checkout trazable ✅ |
| 65 | SLICE-65 | R2-A | Ingreso stock + guía/lote | RF-085 | inventario + auditoría ✅ |
| 66 | SLICE-66 | R2-A | Auditoría rango/categoría | RF-086 | extiende RF-070 ✅ |
| 67 | SLICE-67 | R2-A | Stock insights | RF-087 | queries reporte ✅ |
| 68 | SLICE-68 | R2-A | Cierre inventario | RF-088 | caso de uso ✅ |
| 69 | SLICE-69 | R2-A | Modelo plantilla Atria POS | RF-089 | config dominio ✅ |
| 70 | SLICE-70 | R2-B | UI usuarios | RF-080 | SC-*-UI-01 ✅ |
| 71 | SLICE-71 | R2-B | UI carrito | RF-082 | SC-*-UI-01 ✅ |
| 72 | SLICE-72 | R2-B | UI código vendedor | RF-084 | SC-*-UI-01 ✅ |
| 73 | SLICE-73 | R2-B | UI stock / ingreso | RF-085, RF-087 | SC-*-UI-01 ✅ |
| 74 | SLICE-74 | R2-B | UI auditoría / inventario | RF-086–088 | SC-*-UI-01 ✅ |
| 75 | SLICE-75 | R2-B | UI shell Atria (tema, Vender) | — | SC-075-UI-* ✅ |
| 76 | SLICE-76 | R2-B | UI menú plantilla | RF-089 | SC-076-UI-* ✅ |
| 77 | SLICE-77 | Cierre | Cierre revisión 2 + push `main` | — | SC-077-* ✅ |

## Revisión intermedia piloto UX (post-R2)

Detalle: [`20c-plan-revision-intermedia-operacion.md`](20c-plan-revision-intermedia-operacion.md). SLICE-50 BLE **paralelo**, no bloquea.

| # | Slice | Fase | Resumen | RF prop. | DoD resumido |
|---|-------|------|---------|----------|--------------|
| 78 | SLICE-78 | R-INT | Entradas ñ/RUT | RF-080 | SC-078-* ✅ |
| 79 | SLICE-79 | R-INT | Lista stock productos | RF-091 | SC-079-* ✅ |
| 80 | SLICE-80 | R-INT | Retiro guía BLE Vender | RNF-041 | SC-080-* ✅ |
| 81 | SLICE-81 | R-INT | PDF etiquetas QR | RF-092 | SC-081-* ✅ |
| 82 | SLICE-82 | R-INT | Cambiar / expirar sesión | RF-093 | SC-082-* ✅ |
| 83 | SLICE-83 | Cierre | Cierre revisión intermedia | — | SC-083-* ✅ |
| 84 | SLICE-84 | R-INT | Nuevo producto desde stock | RF-091 | SC-084-* ✅ |

## Revisión siguiente — dos bloques

| Bloque | Plan | Slices | Estado |
|--------|------|--------|--------|
| **A** — Operación y productos (scanner-first) | [`21-plan-revision-operacion-productos.md`](21-plan-revision-operacion-productos.md) | SLICE-85…94 | **Cerrado** SLICE-94 |
| **B** — Companion web | [`22-plan-companion-web.md`](22-plan-companion-web.md) | SLICE-95…105 | Gate R4-B ✅ — ver abajo |

Respuestas Gate A: [`23-gate-r4-a-respuestas.md`](23-gate-r4-a-respuestas.md). Gate B: [`23b-gate-r4-b-respuestas.md`](23b-gate-r4-b-respuestas.md).

| # | Slice | Fase | Resumen | RF | DoD resumido |
|---|-------|------|---------|-----|--------------|
| 85 | SLICE-85 | R4-A | Contrato sesión escaneo | RF-094 | SC-085-* ✅ |
| 86 | SLICE-86 | R4-A | Confirmar ingreso desde sesión | RF-085 | SC-086-* ✅ |
| 87 | SLICE-87 | R4-A | UI ingreso escaneo | RF-085 | SC-087-UI-* ✅ |
| 88 | SLICE-88 | R4-A | Conteo inventario escaneo (core) | RF-088 | SC-088-SCAN-* ✅ |
| 89 | SLICE-89 | R4-A | UI conteo escaneo | RF-088 | SC-088-SCAN-UI-* ✅ |
| 90 | SLICE-90 | R4-A | Cambio producto core | RF-095 | SC-090-* ✅ |
| 91 | SLICE-91 | R4-A | UI cambio mostrador | RF-095 | SC-091-UI-* ✅ |
| 92 | SLICE-92 | R4-A | Nota de crédito | RF-096 | SC-092-* ✅ |
| 93 | SLICE-93 | R4-A | Factura | RF-097 | SC-093-* ✅ |
| 94 | SLICE-94 | Cierre | Cierre bloque A | — | SC-094-* ✅ |

### Bloque B — companion web WiFi

| # | Slice | Fase | Resumen | RF | DoD resumido |
|---|-------|------|---------|-----|--------------|
| 95 | SLICE-95 | R4-B | Gate companion LAN | RF-098 | SC-095-* ✅ |
| 95b | SLICE-95b | R4-B | Spike cámara HTTP | RNF-041 | Runbook ✅ (manual piloto) |
| 96 | SLICE-96 | R4-B | Emparejamiento core | RF-098 | SC-096-* ✅ |
| 97 | SLICE-97 | R4-B | Servidor HTTP LAN | RF-098 | SC-097-* ✅ |
| 98 | SLICE-98 | R4-B | WebSocket ingress | RF-098 | SC-098-* ✅ |
| 99 | SLICE-99 | R4-B | QR POS + arranque | RF-098 | SC-099-* ✅ |
| 100 | SLICE-100 | R4-B | PWA companion | RF-098 | SC-100-* ✅ |
| 101 | SLICE-101 | R4-B | E2E vender | RF-098 | SC-101-* ✅ |
| 102 | SLICE-102 | R4-B | E2E ingreso scan | RF-085 | SC-102-* ✅ |
| 103 | SLICE-103 | R4-B | E2E conteo scan | RF-088 | SC-103-* ✅ |
| 104 | SLICE-104 | R4-B | Deprecar BLE default | RNF-041 | SC-104-* ✅ |
| 105 | SLICE-105 | Cierre | Cierre bloque B | — | SC-105-* ✅ |

### Companion HTTPS (post Bloque B)

Decisiones en [23c](23c-companion-https-respuestas.md). Cada slice 107–112 se abre en Plan y solo pasa a Agent tras confirmación.

| # | Slice | Fase | Resumen | RF | DoD resumido |
|---|-------|------|---------|-----|--------------|
| 106 | SLICE-106 | Docs | Decisiones HTTPS | RF-098 | DEC-059…062 ✅ |
| 107 | SLICE-107 | Adapters | Enlace corto `/c/{codigo}` | RF-098 | SC-107-* ✅ |
| 108 | SLICE-108 | PWA | Pantalla simple | RF-098 | SC-108-* ✅ |
| 109 | SLICE-109 | Adapters | HTTPS + CA instalable | RF-098 | SC-109-* ✅ |
| 110 | SLICE-110 | PWA | Cámara o manual | RF-098 | SC-110-* ✅ |
| 111 | SLICE-111 | POS | Estado celular conectado | RF-098 | SC-111-* ✅ |
| 112 | SLICE-112 | E2E | Vender, ingreso y conteo | RF-098 | SC-112-* ✅ |
| 113 | SLICE-113 | POS | Root PWA válido + QR bloqueado | RF-098 | SC-113-* ✅ |
| 114 | SLICE-114 | POS | TLS IP del QR + hint CA | RF-098 | SC-114-* ✅ |
| 115 | SLICE-115 | Ops | Smoke PC + acta piloto | RF-098 | SC-115-* ✅ |
| 116 | SLICE-116 | Docs | DEC app Android LAN | RF-098 | DEC-063 ✅ |
| 117 | SLICE-117 | App | Parser enlace `/c/{codigo}` | RF-098 | SC-117-* ✅ |
| 118 | SLICE-118 | App | Cliente pair + WebSocket | RF-098 | SC-118-* ✅ |
| 119 | SLICE-119 | App | Pantalla Conectar LAN | RF-098 | SC-119-* ✅ |
| 120 | SLICE-120 | App | Cámara de productos + dedup | RF-098 | SC-120-* ✅ |
| 121 | SLICE-121 | App | Integración servidor + APK | RF-098 | SC-121-* ✅ |
| 122 | SLICE-122 | App | Leer QR del POS en Conectar | RF-098 | SC-122-01 ✅ |
| 123 | SLICE-123 | App | Permiso de cámara y error en español | RF-098 | SC-123-* ✅ |
| 124 | SLICE-124 | App | ProGuard release cámara ML Kit | RF-098 | SC-124-02 ✅ SC-124-01 manual |
| 125 | SLICE-125 | App | Un solo pop al leer QR del POS | RF-098 | SC-125-01 ✅ |
| 126 | SLICE-126 | POS | IP fresca al generar QR | RF-098 | SC-126-01 ✅ |
| 127 | SLICE-127 | POS | IP e interfaz en diálogo QR | RF-098 | SC-127-* ✅ |
| 128 | SLICE-128 | POS | Score multi-NIC Ethernet/WiFi | RF-098 | SC-128-01 ✅ |
| 129 | SLICE-129 | POS | Aviso cert vs IP sin hot-reload | RF-098 | SC-129-01 ✅ |
| 130 | SLICE-130 | POS | Un Future por diálogo QR | RF-098 | SC-130-01 ✅ |
| 131 | SLICE-131 | App | Un envío por toque Escanear | RF-098 | SC-131-* ✅ |
| 132 | SLICE-132 | App | Aterrizaje en visor al conectar | RF-098 | SC-132-* ✅ |

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