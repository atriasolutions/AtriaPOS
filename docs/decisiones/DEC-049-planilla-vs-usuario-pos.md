# DEC-049 — Planilla colaboradores vs usuario POS

**Estado:** ✅ Decidido  
**Fecha:** 2026-11-24  
**RF:** RF-083, RF-084  
**Slice:** SLICE-63

## Contexto

No todos los vendedores operan caja. El código vendedor debe trazarse en ventas sin mezclar credenciales PIN del POS.

## Decisión

1. Entidad **`Collaborator`** (planilla) separada de **`User`** (login POS).
2. **`sellerCode`** único por tienda entre colaboradores **activos**; normalizado mayúsculas A–Z, 0–9, sin ñ.
3. CRUD planilla solo **jefe de tienda** (`Permission.gestionarPlanilla`).
4. Asociación venta ↔ código vendedor en **SLICE-64** (RF-084): **`sellerCode` obligatorio** en checkout plantilla Atria POS.

## Consecuencias

- Tabla Drift `collaborators` (schema v14).
- API-011 en doc 07.
- UI planilla y selección en checkout: slices R2-B posteriores.