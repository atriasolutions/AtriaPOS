# DEC-048 — Permisos por herencia (plantilla Atria POS)

**Estado:** ✅ Decidido  
**Fecha:** 2026-11-24  
**RF:** RF-081  
**Slice:** SLICE-61

## Contexto

RF-002 definía matriz plana dueño/supervisor/cajero. Revisión 2 nombra roles lógicos (jefe de tienda, jefe de turno, cajero) y requiere **herencia** sin duplicar reglas.

## Decisión

1. Implementar `RoleCapabilities` con herencia: **cajero** ⊂ **supervisor** ⊂ **dueño** (enums técnicos sin cambio).
2. Permisos semánticos nuevos (`consultarReportes`, `consultarAuditoria`, etc.) en lugar de reutilizar `anularVenta`.
3. Matriz fija plantilla Atria POS en código; plantillas runtime en SLICE-69.

## Consecuencias

- `AuthPolicy` delega a `RoleCapabilities`.
- Casos de uso de reportes/auditoría/certificado usan permisos dedicados.
- `UserRole.displayLabelAtriaPos` para UI futura.