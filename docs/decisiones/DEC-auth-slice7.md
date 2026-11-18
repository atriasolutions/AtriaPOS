# DEC — Auth SLICE-7 (RF-002)

- **Estado:** Aceptado
- **Fecha:** 2026-11-18

| DEC | Decisión |
|-----|----------|
| 024 | Hash PIN con **bcrypt**; solo hash en persistencia |
| 025 | Sesión in-memory; `expiresAt` default 15 min |
| Roles | `DUENO`, `SUPERVISOR`, `CAJERO` (matriz en doc 04) |
| Seeds | Solo en tests; demo opcional documentado, no producción |
| Lecturas | Búsqueda/carro sin auth obligatorio en S7 |