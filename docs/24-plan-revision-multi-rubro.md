# 24 — Revisión multi-rubro (R5) — configuración por tienda

**Estado:** en curso (Gate SLICE-161; código SLICE-162+)  
**Prerrequisito:** R4 companion + operación productos cerrada (SLICE-160).  
**No sustituye:** revisión 3 SII/Kora ([`20b-esbozo-revision-3.md`](20b-esbozo-revision-3.md)).

## Objetivo

Un binario **Atria POS** adaptable a distintos rubros en Chile mediante **perfil operativo por tienda**, editable por el **dueño del local** (fase 1, sin consola multi-cadena).

## Fuera de alcance (fase 1)

- RF-033 promociones y RF-034 **fiado** ([DEC-068](decisiones/DEC-068-fiado-fuera-r5.md)).
- Administrador de sistema / cadena multi-tienda.
- Presets empaquetados «rubro botillería» (solo flags sueltos v1).
- Integración Transbank en vivo (flag + stub; slice 166).
- Kora / emisión centralizada R3.

## Slices

| # | Slice | Entregable |
|---|-------|------------|
| 161 | Gate R5 | DEC-067/068, RF-099, contrato 07, acceptance |
| 162 | Core | `StoreOperationalOverrides`, GET, merge ATRIA_POS |
| 163 | API | PATCH dueño, validación, auditoría CONFIG |
| 164 | Cableado | Checkout, menú, ingreso guía/lote |
| 165 | UI | Pantalla configuración tienda |
| 166 | Pagos | Flag Transbank + documentación integración |
| 167 | Inventario | Caducidad en ingreso si flag activo |

## Gate R5 (SLICE-161)

Checklist: [`test/acceptance/slice_161_gate_multi_rubro.md`](../test/acceptance/slice_161_gate_multi_rubro.md).

## Precedencia config

`effectiveFeatures = plantilla(posTemplateId) ⊕ overrides tienda` — ver [DEC-067](decisiones/DEC-067-perfil-operativo-tienda.md).

## Integraciones candidatas (roadmap)

Pantalla dueño (fase 1): solo los overrides RF-099. Las filas siguientes orientan fase 2+; sin UI de roadmap en v1.

| Integración | Relación con hoy | Notas |
|---------------|------------------|--------|
| Terminal tarjeta (Transbank POS, Getnet, etc.) | `transbankIntegration` / UI «Pago integrado con tarjeta» | Slice 166 stub; cobro con terminal, no sustituye `cardPaymentCheckout` (débito/crédito manual) |
| Companion escáner / balanza | R4 companion | Profundizar peso y código de barras en mostrador |
| Export contable (contador / ERP liviano) | Fuera MVP | CSV/XML ventas y notas de crédito |
| Kora respaldo / emisión | Complemento opcional (doc 14) | No bloquear núcleo local-first |
| Pasarela alternativa (Mercado Pago, etc.) | Nuevo `PosFeature` futuro | Misma categoría UI «Ventas y cobro» |
| E-commerce / stock omnicanal | Fuera R5 fase 1 | Reservar; no implementar en perfil v1 |

## Presets de plantilla (fase 2)

Atajos de overrides; no sustituyen `posTemplateId` en fase 1 (solo flags sueltos).

| Preset | Orientación | Overrides típicos |
|--------|-------------|-------------------|
| Barrio mínimo | Referencia test | `barrioMinTest` en registry |
| Retail alimentos | Supermercado / botillería | Guía/lote, caducidad, cierre inventario, DTE ON |
| Farmacia / regulado | Trazabilidad estricta | Caducidad, auditoría, DTE ON |
| Servicios | Sin recepción masiva | Factura/cobro ON; inventario liviano OFF donde aplique |
| Mayorista | B2B | Factura, guía/lote; vendedor en cobro según operación |

## Notas de producto (config dueño)

- **`cardPaymentCheckout`**: hoy viene de plantilla; el switch «Pago integrado con tarjeta» no debe ocultar débito/crédito manual (features separados en dominio).
- **`collaboratorPlanilla`**: no es override v1; activar «Código vendedor en cobro» asume planilla operativa.
- **Promos y fiado**: fuera R5 ([DEC-068](decisiones/DEC-068-fiado-fuera-r5.md)); no prometer en pantalla.