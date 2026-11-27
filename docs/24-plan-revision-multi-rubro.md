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