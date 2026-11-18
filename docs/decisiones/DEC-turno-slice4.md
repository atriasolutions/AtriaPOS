# DEC — Turno SLICE-4

- **Estado:** Aceptado
- **Fecha:** 2026-11-18

| Tema | Decisión |
|------|----------|
| DEC-013 | Un turno **ABIERTO** por `storeId` |
| DEC-015 | Cierre **siempre permitido**; solo reporta `differenceClp` |
| Checkout sin turno | `TURNO_CERRADO` → HTTP **403** |
| Efectivo esperado | `openingCashClp + Σ (efectivo cobrado − vuelto)` por venta con pago EFECTIVO |