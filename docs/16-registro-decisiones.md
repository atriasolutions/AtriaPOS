# 16 — Registro maestro de decisiones (DEC)

Estado global Gate 2: **🟡 En progreso**

Leyenda estado: `⬜ Abierto` | `🔄 En análisis` | `✅ Decidido` | `⏸ Postergado`

| DEC | Prioridad | Tema | Estado | Artefacto | Fase |
|-----|-----------|------|--------|-----------|------|
| DEC-001 | P0 | Monorepo (Melos / manual / VGV) | ✅ | [ADR](decisiones/DEC-001-monorepo-manual.md) | F1 |
| DEC-002 | P0 | ORM SQLite (drift vs sqflite) | ✅ | [ADR](decisiones/DEC-002-003-catalogo-slice1.md) + 08b | F1/F4 |
| DEC-003 | P0 | IDs entidades (UUID v4 / ULID) | ✅ | [ADR](decisiones/DEC-002-003-catalogo-slice1.md) | F1 |
| DEC-004 | P0 | Transacción única checkout | ✅ | [ADR](decisiones/DEC-004-checkout-transaccion.md) | SLICE-45 |
| DEC-005 | P0 | API in-process vs HTTP tests | ✅ | [ADR](decisiones/DEC-005-api-in-process.md) | SLICE-45 |
| DEC-006 | P0 | Catálogo códigos error API | ✅ | [ADR](decisiones/DEC-006-010-precios-catalogo.md) + 07 | F1 |
| DEC-007 | P0 | IVA: precio con IVA incluido | ✅ | [ADR](decisiones/DEC-006-010-precios-catalogo.md) | F2 |
| DEC-008 | P0 | Redondeo CLP (línea vs total) | ✅ | [ADR](decisiones/DEC-006-010-precios-catalogo.md) | F2 |
| DEC-009 | P0 | Pesables en MVP (sí/no) | ✅ | [ADR](decisiones/DEC-006-010-precios-catalogo.md) | F2 |
| DEC-010 | P0 | Barcode duplicado (rechazar/advertir) | ✅ | [ADR](decisiones/DEC-006-010-precios-catalogo.md) | F2 |
| DEC-011 | P0 | Carro: uno por cajero / por turno | ✅ | [ADR](decisiones/DEC-011-carro-turno.md) | SLICE-45 |
| DEC-012 | P0 | Medios de pago MVP (EFECTIVO, OTRO, …) | ✅ | [ADR](decisiones/DEC-012-medios-pago.md) | SLICE-45 |
| DEC-013 | P0 | Un turno abierto por dispositivo | ✅ | [ADR](decisiones/DEC-turno-slice4.md) (MVP: por tienda) | F2 |
| DEC-014 | P0 | Anulación venta: ventana y stock | ✅ | [DEC-anulacion-slice10](decisiones/DEC-anulacion-slice10.md) | SLICE-10 |
| DEC-015 | P0 | Tolerancia diferencia cierre caja | ✅ | [ADR](decisiones/DEC-turno-slice4.md) (solo reporte S4) | F2 |
| DEC-016 | P0 | Esquema SQLite v1 (DDL) | ✅ | 08b (products) | F4 |
| DEC-017 | P0 | Índices búsqueda producto | ✅ | 08b | F4 |
| DEC-018 | P1 | Cifrado DB en reposo | ⬜ | 05 + ADR | F4 |
| DEC-019 | P0 | Tipos DTE MVP (39 afecta/exenta) | ✅ | [ADR](decisiones/DEC-dte-slice5.md) (tipo 39) | SLICE-5 |
| DEC-020 | P0 | Adaptador DTE: directo SII vs API | ✅ | [ADR](decisiones/DEC-dte-slice5.md) (`FakeDteGateway`) | SLICE-5 |
| DEC-021 | P0 | Custodia certificado digital | ✅ | [DEC-sii-slice8](decisiones/DEC-sii-slice8.md) + runbooks/sii-cert.md | SLICE-8 |
| DEC-022 | P0 | Cola DTE: reintentos y TTL | ✅ | [ADR](decisiones/DEC-dte-slice5.md) (retry manual API-005) | SLICE-5 |
| DEC-023 | P0 | Idempotencia emisión (`saleId`) | ✅ | [ADR](decisiones/DEC-dte-slice5.md) | SLICE-5 |
| DEC-043 | P0 | CAF local y folios en SQLite (F3-4) | ✅ | [DEC-sii-slice8](decisiones/DEC-sii-slice8.md) + 08b v7 | SLICE-8 |
| DEC-024 | P1 | Hash PIN (argon2/bcrypt) | ✅ | [ADR](decisiones/DEC-auth-slice7.md) (bcrypt S7) | SLICE-7 |
| DEC-025 | P1 | Sesión inactividad (minutos) | ✅ | [ADR](decisiones/DEC-auth-slice7.md) (15 min) | SLICE-7 |
| DEC-026 | P1 | Android primero vs Win paralelo | ⬜ | ADR | F6 |
| DEC-027 | P1 | Escáner: cámara / HID / ambos | ⬜ | ADR | F6 |
| DEC-028 | P1 | Impresión ticket/boleta en MVP | ⬜ | ADR | F6 |
| DEC-029 | P2 | `PaymentTerminalPort` diseño | ⬜ | 07 | F7 |
| DEC-030 | P2 | Orden cobro vs DTE | ⬜ | ADR | F7 |
| DEC-031 | P2 | Eventos sync Kora (complemento) | ⬜ | 14 + ADR | F7 |
| DEC-032 | P2 | Backend sync (sí/no/cuándo) | ⏸ | 06 | F7 |
| DEC-033 | P1 | CI GitHub Actions | ✅ | [DEC-ci-slice11](decisiones/DEC-ci-slice11.md) | SLICE-11 |
| DEC-034 | P0 | Inyección dependencias core | ✅ | [DEC-ui-slice6](decisiones/DEC-ui-slice6.md) + [DEC-005](decisiones/DEC-005-api-in-process.md) | SLICE-7 |
| DEC-035 | P1 | Soft delete productos | ⬜ | 08b | F4 |
| DEC-036 | P1 | Backup export local | ⬜ | ADR | F4 |
| DEC-037 | P2 | OpenAPI desde contrato 07 | ⬜ | spec | F7 |
| DEC-038 | P1 | Auditoría campos mínimos | ⬜ | 04 | F2 |
| DEC-039 | P0 | DEC ya en Gate 1 (D1–D7) | ✅ | 12, 14 | — |
| DEC-040 | P3 | Multi-tienda un dispositivo | ⏸ | — | F7 |
| DEC-041 | P0 | Inventario: stock en `products` + movimientos | ✅ | [ADR](decisiones/DEC-inventario-slice2.md) + 08b | SLICE-2 |
| DEC-042 | P0 | Venta SLICE-3 sin DTE/turno; pagos EFECTIVO/OTRO | ✅ | [ADR](decisiones/DEC-venta-slice3.md) + 07 | SLICE-3 |
| DEC-044 | P1 | Marca Atria POS y repo canónico | ✅ | [ADR](decisiones/DEC-044-marca-atria-pos.md) | SLICE-55/56 |
| DEC-045 | P1 | Sin nombres de persona en repo | ✅ | [ADR](decisiones/DEC-045-sin-nombres-persona.md) | SLICE-57 |
| DEC-046 | P1 | Repo org atriasolutions/AtriaPOS | ✅ | [ADR](decisiones/DEC-046-repo-org-atriasolutions.md) | SLICE-58 |
| DEC-047 | P0 | Username/PIN sin ñ; UUID usuario | ✅ | [ADR](decisiones/DEC-047-credenciales-username-pin.md) | SLICE-60 |
| DEC-048 | P0 | Permisos herencia Atria POS | ✅ | [ADR](decisiones/DEC-048-permisos-herencia-atria-pos.md) | SLICE-61 |
| DEC-049 | P0 | Planilla vs usuario POS | ✅ | [ADR](decisiones/DEC-049-planilla-vs-usuario-pos.md) | SLICE-63 |
| DEC-050 | P1 | Cambio sesión con turno cerrado | ✅ | [ADR](decisiones/DEC-050-cambio-sesion-turno-cerrado.md) | SLICE-82 |
| DEC-051 | P1 | PDF etiquetas QR A4 3×5 | ✅ | [ADR](decisiones/DEC-051-pdf-etiquetas-qr.md) | SLICE-81 |
| DEC-052 | P0 | Sesión escaneo unificada (ingreso/conteo) | ✅ | [Gate R4-A](decisiones/DEC-gate-r4-a-bloque-a.md) | SLICE-85 |
| DEC-053 | P1 | ScannerIngress en operación stock | ✅ | [Gate R4-A](decisiones/DEC-gate-r4-a-bloque-a.md) | SLICE-85 |
| DEC-054 | P0 | Cambio producto + permiso | ✅ | [Gate R4-A](decisiones/DEC-gate-r4-a-bloque-a.md) | SLICE-90 |
| DEC-055 | P0 | NC/factura núcleo; sin Transbank | ✅ | [Gate R4-A](decisiones/DEC-gate-r4-a-bloque-a.md) | SLICE-92 |
| DEC-056 | P0 | Companion web WiFi en LAN | ✅ | [Gate R4-B](decisiones/DEC-gate-r4-b-bloque-b.md) | SLICE-95 |
| DEC-057 | P0 | Emparejamiento 1 slot + QR por flujo | ✅ | [Gate R4-B](decisiones/DEC-gate-r4-b-bloque-b.md) | SLICE-96 |
| DEC-058 | P1 | WS scan + ScannerIngress | ✅ | [Gate R4-B](decisiones/DEC-gate-r4-b-bloque-b.md) | SLICE-98 |
| DEC-059 | P0 | Companion HTTPS local + CA instalable | ✅ | [Companion HTTPS](decisiones/DEC-companion-https.md) | SLICE-109 |
| DEC-060 | P0 | QR con enlace corto `/c/{codigo}` | ✅ | [Companion HTTPS](decisiones/DEC-companion-https.md) | SLICE-107 |
| DEC-061 | P0 | Cámara opcional; manual si falla | ✅ | [Companion HTTPS](decisiones/DEC-companion-https.md) | SLICE-110 |
| DEC-062 | P1 | USB y Wi-Fi, misma IP activa | ✅ | [Companion HTTPS](decisiones/DEC-companion-https.md) | SLICE-109 |
| DEC-063 | P0 | App Android LAN, cámara nativa, sin CA en el teléfono | ✅ | [Companion Android](decisiones/DEC-companion-android.md) | SLICE-116 |
| DEC-065 | P0 | Companion armed: un envío por toque Escanear (Android + PWA) | ✅ | [Armed scan](decisiones/DEC-companion-armed-scan.md) | SLICE-131, 137 |

---

## Plantilla rápida al cerrar un DEC

```text
DEC-0NN: [Título]
Decisión: ...
Alternativas descartadas: ...
Impacto: docs 0X, 0Y
Fecha / participantes:
```

Copia completa en [`decisiones/DEC-XXX-slug.md`](decisiones/README.md).

---

## Conteo para Gate 2

| Prioridad | Total | Decidido | Pendiente |
|-----------|-------|----------|-----------|
| P0 | 22 (excl. DEC-039) | 2 | 20 |
| P1 | 12 | 0 | 12 |
| P2 | 5 | 0 | 5 |
| P3 | 1 | 0 | 1 |

**Gate 2 mínimo:** todos **P0** en ✅ (salvo DEC explícitamente pospuesto con riesgo aceptado documentado en `11`).

**Gate 2 global (2026-11-20):** **parcial** — SLICE-45 cerró retroactivamente DEC-004, 005, 011, 012 (y DEC-034). Resto P0 abierto sin bloquear demo MVP; ver [`17-cierre-gate-2.md`](17-cierre-gate-2.md) § Retroactivo SLICE-45.