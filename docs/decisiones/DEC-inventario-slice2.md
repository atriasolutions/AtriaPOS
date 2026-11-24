# DEC — Inventario SLICE-2

- **Estado:** Aceptado
- **Fecha:** 2026-11-18
- **Prioridad:** P0 (slice)

| Tema | Decisión |
|------|----------|
| Cantidad disponible | Columna `products.stock` |
| Auditoría | Tabla `stock_movements` append-only |
| Stock negativo tras ajuste | Rechazar → `VALIDACION` |
| Motivos | `MERMA`, `AJUSTE`, `RECEPCION`, `CORRECCION` |
| Supervisor / RF-002 | Fuera de slice; `actor_id` nullable en movimiento |

**SLICE-65 (RF-085):** ingreso `RECEPCION` solo vía `POST .../stock-receipts` con `guide_ref` y `lot_ref` obligatorios; `adjustments` no acepta motivo `RECEPCION`.