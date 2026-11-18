# DEC — Anulación venta SLICE-10 (RF-032)

- **Estado:** Aceptado
- **Fecha:** 2026-11-18
- **Cierra:** DEC-014

| Tema | Decisión |
|------|----------|
| Roles | `Permission.anularVenta` — dueño y supervisor |
| Ventana | Mismo turno **abierto** que la venta |
| Stock | `ANULACION_VENTA` por línea (+qty) |
| DTE EMITIDA | Rechazar; NC manual fuera de MVP |
| DTE PENDIENTE | Quitar de cola al anular |
| DTE RECHAZADA_SII | Permitir anular |
| Re-anulación | `CONFLICTO` |
| Folio consumido | No se devuelve al CAF (DEC-043) |
| Cierre caja | Ventas `ANULADA` excluidas de totales |

DoD: tests SC-032-01…07 en verde. UI Flutter (SC-032-UI-01): lista turno + anular en app.